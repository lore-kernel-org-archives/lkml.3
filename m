Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab3FNXAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 19:00:31 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:35934 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab3FNXA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 19:00:29 -0400
MIME-Version: 1.0
In-Reply-To: <1371250092.2490.7.camel@x230>
References: <CAE9FiQVu5QyxaKsYzzQoroQD=TvsziHzDOtoeg=FvhZ8HyN5yw@mail.gmail.com>
	<CAErSpo7ChfRiEn0eR1rf-mVheUS9Yf8f+j4n78PJcGYh+yMVgA@mail.gmail.com>
	<CAE9FiQXkDg7Y336S=DXoms44=5HLaiUx=sWviupz1fJmaDUEzQ@mail.gmail.com>
	<CAE9FiQU5c=ztzbskNnYFFKF9V5zO+jnRcMBCivLxA1F3fSfX5w@mail.gmail.com>
	<20130401235256.GA31966@google.com>
	<CAE9FiQV8cPh-s6=EQu_cZTtn86+NwZE5KuGMhf43aOhzkL=hwA@mail.gmail.com>
	<CAErSpo7Jni1ZSf_W=vB3kqsucPpoepa2Q5g=77a6D3FaPwe9LA@mail.gmail.com>
	<CAE9FiQWjQXwiTWju6cBc_o25jy_wmZ1u+Pifh1wdnxtV=i5ENw@mail.gmail.com>
	<CAErSpo7=a-wX6BLbm_O1nUMMrQHOgtSm3xZHKuRqaz8rnKSbRA@mail.gmail.com>
	<CAE9FiQUbw7OUhRB+gKMxkuE9+nm9097+mwZ2z4adO8Hv_NjF1Q@mail.gmail.com>
	<20130614141101.GA29452@google.com>
	<CAE9FiQVr-OWeqEHFXn0MjNiSD0WM=FNO_DFo6m9UbbG60uonpw@mail.gmail.com>
	<CAErSpo7grN-93zZfBJOHZH-pR1wDYrojTwt=B=++QqA0rPb3Rg@mail.gmail.com>
	<CAE9FiQUO350kqrXB5=yQ-OxOeSJj4+P6WPg4gGgXxFEvfoLyng@mail.gmail.com>
	<CAErSpo6vEOw10YV=Sou6wjjSc2GWr-oX=Dvbt7Xt=RJKi4RELw@mail.gmail.com>
	<CAE9FiQWevd6ZNDdqGkqbLrGujKYuTiwibPAT+30VPpC_H-rLJA@mail.gmail.com>
	<CAErSpo66qtgg8=BqX+4sm4h1vXD5gR6aiH7hHK7gvz1x3rEQZA@mail.gmail.com>
	<CAE9FiQWxDhagFNAYc2eNDe_1jYtVTa5Azg0zifiprND5m3CmMw@mail.gmail.com>
	<1371248853.2490.5.camel@x230>
	<CAE9FiQWPvOYK2W0VSRuMyfj9Edbw1BSp-W91HjPyszPK0ZBcjg@mail.gmail.com>
	<1371250092.2490.7.camel@x230>
Date: Fri, 14 Jun 2013 16:00:28 -0700
X-Google-Sender-Auth: 4c5fE9QpNuFN_WdpJ_M2gdeAqaY
Message-ID: <CAE9FiQVRAkuDau9JWW97SBpw6F8qUcxDFa_Mg_XAnjf+mzttWg@mail.gmail.com>
Subject: Re: [PATCH] PCI: Remove not needed check in disable aspm link
From: Yinghai Lu <yinghai@kernel.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Roman Yepishev <roman.yepishev@gmail.com>,
        Jiang Liu <jiang.liu@huawei.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 3:48 PM, Matthew Garrett
<matthew.garrett@nebula.com> wrote:
> On Fri, 2013-06-14 at 15:40 -0700, Yinghai Lu wrote:
>> On Fri, Jun 14, 2013 at 3:27 PM, Matthew Garrett
>> <matthew.garrett@nebula.com> wrote:
>> > On Fri, 2013-06-14 at 15:17 -0700, Yinghai Lu wrote:
>> >
>> >> after those two patches, it aspm_disabled is set, via _osc early,
>> >> pre-1.1 devices aspm register will be touched even aspm_force is not specified.
>> >
>> > I don't follow. We were previously automatically disabling ASPM on
>> > pre-1.1 devices even if _OSC didn't give us control.
>>
>> I don't think so, we just moved _OSC support/control setting before pci scan
>> in 3.8 and revert that in v3.9.
>
> Right, sorry, I don't mean _OSC, I mean the FADT flag. We were
> previously automatically disabling ASPM on pre-1.1 devices even if the
> FADT flag was set.

so in that case aspm_disabled, never get set.
booting path: pcie_aspm_init_link_state will not touch aspm on pre-1.1 devices.

late, FADT checking will cause pcie_clear_aspm() get called, it will
call __pci_disable_link_state, and because following line in
pcie_aspm_link()
        /* Nothing to do if the link is already in the requested state */
        state &= (link->aspm_capable & ~link->aspm_disable);
        if (link->aspm_enabled == state)
                return;
aspm in pre-1.1 devices still does not get touched.

Maybe I miss something.

Thanks

Yinghai
