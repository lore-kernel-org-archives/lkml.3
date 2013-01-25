Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab3AYN67 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 08:58:59 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:25880 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab3AYN65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 08:58:57 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFGji0LFus=
X-RZG-CLASS-ID: mo00
Date: Fri, 25 Jan 2013 14:58:35 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Jan Beulich <JBeulich@suse.com>
Cc: KY Srinivasan <kys@microsoft.com>, "bp@alien8.de" <bp@alien8.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH RESEND 1/1] X86: Handle Hyper-V vmbus interrupts as
 special hypervisor interrupts
Message-ID: <20130125135834.GA18361@aepfle.de>
References: <1358990259-22551-1-git-send-email-kys@microsoft.com>
 <5101035D02000078000B8FFD@nat28.tlf.novell.com>
 <27092660926e4d3f80394697cc0dc858@SN2PR03MB061.namprd03.prod.outlook.com>
 <51016C3202000078000B943E@nat28.tlf.novell.com>
 <f6cbfec9c014433fa54af61d8f436ebb@SN2PR03MB061.namprd03.prod.outlook.com>
 <20130124185943.GA19194@aepfle.de>
 <510243B802000078000B9735@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <510243B802000078000B9735@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21.rev5632 (2013-01-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, Jan Beulich wrote:

> >>> On 24.01.13 at 19:59, Olaf Hering <olaf@aepfle.de> wrote:
> > On Thu, Jan 24, KY Srinivasan wrote:
> > 
> > 
> >> > Question is - considering you stated that this is supported
> >> > starting in Win8, doesn't Hyper-V itself announce that
> >> > capability in some explicit way?
> >> 
> >> Thanks Jan. Unfortunately I don't think tis interrupt delivery model
> >> is specified via a "feature" bit (I will check with the Windows guys).
> >> Perhaps, we can have a Hyper-V specific compilation switch to address
> >> the Xen emulation issue.
> > 
> > Would that really help if both pvops XEN_PVHVM and HYPERV are enabled in
> > the config? I assume at this point the access to the DMI data is not yet
> > possible.
> 
> As just said in another reply - with XEN_PVHVM, there's no problem,
> since Xen gets checked for first. There's only a problem when
> !XEN_PVHVM, because in that case Hyper-V will be probed for.
> And the problem can only get bigger when on top of that the
> out-of-tree PV drivers are intended to be used.

Yes, xen_cpuid_base() recognizes Xen as hypervisor even with
'viridian=1' in the .cfg file.
 I think if there is no feature bit for this, the DMI can be used
because its appearently available before the host is checked:

...
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Xen HVM domU, BIOS 4.1.3_06-0.7.1 12/05/2012
[    0.000000] Hypervisor detected: Microsoft HyperV
[    0.000000] HyperV: features 0x70, hints 0x0
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
...

Olaf
