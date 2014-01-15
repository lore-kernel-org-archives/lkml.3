Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbaAOR1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 12:27:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51658 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbaAOR11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 12:27:27 -0500
Message-ID: <52D6C4B6.8010804@zytor.com>
Date: Wed, 15 Jan 2014 09:26:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
CC: hpa@linux.intel.com, jingbai.ma@hp.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, bp@alien8.de, ebiederm@xmission.com,
        akpm@linux-foundation.org, fengguang.wu@intel.com
Subject: Re: [RESEND PATCH v10] x86, apic, kexec, Documentation: Add disable_cpu_apicid
 kernel parameter
References: <20140115064458.1545.38775.stgit@localhost6.localdomain6> <20140115170525.GF3180@redhat.com>
In-Reply-To: <20140115170525.GF3180@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2014 09:05 AM, Vivek Goyal wrote:
> 
> I think this is a reasonable approach to solve the issue. Use a command
> line to not bring up specific cpu in second kernel which can create
> problems.
> 
> Acked-by: Vivek Goyal <vgoyal@redhat.com>
> 
> hpa, I know you are not excited about this approach. If you made up your
> mind that this appoarch is not worth pursuing, please do suggest what
> would you like to see and we can give that a try.
> 
> We want to solve this problem as on large memory machines saving dump can
> take lot of time and we want to bring up multiple cpus and speed up
> compression and save on dump time.
> 

I'm not excited about kdump's reliance on the command line, since it
seems to be a neverending source of trouble, simply because the command
line is fundamentally intended as a human interface.  However, this
seems relatively harmless in comparison with everything else and I am
much happier with saving the ID in the first kernel rather than trying
to guess if a currently-downed CPU is the BSP.

	-hpa

