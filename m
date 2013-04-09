Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937094Ab3DIQgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 12:36:19 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:38023 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936464Ab3DIQgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 12:36:17 -0400
X-IronPort-AV: E=Sophos;i="4.87,439,1363132800"; 
   d="scan'208";a="3379571"
Message-ID: <1365525374.17014.22.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH-v2] xen: Don't call
 arch_trigger_all_cpu_backtrace in dom0(pvm)
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Jan Beulich <JBeulich@suse.com>
CC: xen-devel <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "zhenzhong.duan@oracle.com" <zhenzhong.duan@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tamon Shiose <tamon.shiose@oracle.com>, Feng Jin <joe.jin@oracle.com>
Date: Tue, 9 Apr 2013 17:36:14 +0100
In-Reply-To: <5162911202000078000CB38E@nat28.tlf.novell.com>
References: <51610A25.4010301@oracle.com>
	 <5162911202000078000CB38E@nat28.tlf.novell.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-08 at 08:42 +0100, Jan Beulich wrote:
> >>> On 07.04.13 at 07:54, Zhenzhong Duan <zhenzhong.duan@oracle.com> wrote:
> > nmi isn't supported in dom0, fallback to general all cpu backtrace code.
> 
> Since when is sending NMIs not supported, and since when is this
> Dom0-specific? If you want to deal with this, you should do so
> properly: Special case sending NMIs in the respective Xen specific
> code (using VCPUOP_send_nmi), and carry this out in a way not
> dependent upon running (un)privileged.

You'd also need to implement the upcall support for receiving NMIs,
which IIRC isn't yet done for pvops.

Ian.

