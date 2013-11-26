Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694Ab3KZSU6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 13:20:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:21739 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757680Ab3KZSM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 13:12:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,776,1378882800"; 
   d="scan'208";a="434562060"
Message-ID: <5294E4A1.9080905@intel.com>
Date: Tue, 26 Nov 2013 10:12:49 -0800
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
CC: Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Siva Krishna Kumar Reddy Yerramreddy 
	<siva.krishna.kumar.reddy.yerramreddy@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [PATCH char-misc-linus 5/5] misc: mic: Fix user space namespace
 pollution from mic_common.h.
References: <cover.1385487752.git.ashutosh.dixit@intel.com> <a0760d072de1531018bdfb4a1f5d1f6e35def26c.1385487752.git.ashutosh.dixit@intel.com>
In-Reply-To: <a0760d072de1531018bdfb4a1f5d1f6e35def26c.1385487752.git.ashutosh.dixit@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 10:15 AM, Ashutosh Dixit wrote:
> Avoid declaring ALIGN() and __aligned() in
> include/uapi/linux/mic_common.h since they pollute user space
> namespace. Also, mic_aligned_size() can be simply replaced simply by
> sizeof() since all structures where mic_aligned_size() is used are
> declared using __attribute__ ((aligned(8)));
> 
> +#define MIC_ALIGN(a, x) (((a) + (x) - 1) & ~((x) - 1))
>  

This is still user namespace.  I would suggest __mic_align() or
_MIC_ALIGN() instead, unless you're actively expecting user code to make
use of this macro (in which case it should be made more robust.)

	-hpa


