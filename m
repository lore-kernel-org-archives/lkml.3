Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab3FRLHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:07:16 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:64773 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505Ab3FRLHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:07:14 -0400
Message-ID: <51C03F5E.3050101@suse.cz>
Date: Tue, 18 Jun 2013 13:07:10 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
CC: "Allan, Bruce W" <bruce.w.allan@intel.com>,
        Jiri Slaby <jirislaby@gmail.com>, Borislav Petkov <bp@alien8.de>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        "x86@kernel.org" <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Subject: Re: e1000e + suspend, 3.9-rc2
References: <20130311191936.GD5000@pd.tnic> <513E355C.4000204@gmail.com> <20130311202537.GF5000@pd.tnic> <20130312171745.GE5370@pd.tnic> <51483B1A.9090704@suse.cz> <51483DAA.7060806@openvz.org> <5148589E.8030509@suse.cz> <804857E1F29AAC47BF68C404FC60A1844D9F3062@ORSMSX103.amr.corp.intel.com> <516C1CE5.1080803@suse.cz> <51B8C8A8.9040900@suse.cz> <51B8E854.9040101@openvz.org>
In-Reply-To: <51B8E854.9040101@openvz.org>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2013 11:29 PM, Konstantin Khlebnikov wrote:
> Jiri Slaby wrote:
>>> pci_pm_suspend(): e1000_suspend+0x0/0x10 [e1000e] returns -2
>>> pci_pm_suspend(): e1000_suspend+0x0/0x10 [e1000e] returns -2
>>> pci_pm_suspend(): e1000_suspend+0x0/0x10 [e1000e] returns -2
>>> pci_pm_suspend(): e1000_suspend+0x0/0x10 [e1000e] returns -2
>>> pci_pm_suspend(): e1000_suspend+0x0/0x10 [e1000e] returns -2
>>> pci_pm_suspend(): e1000_suspend+0x0/0x10 [e1000e] returns -2
>>
>> This still happens with 3.9.5 ...
>>
>> I don't use wired net at all. This usually happens after I enable power
>> saving.
> 
> I guess that '-2' is one of 'return -E1000_ERR_PHY',
> but all that debug messages are omitted by default.

Yeah, I wrote that in one of my past reports too.

> Please enable CONFIG_DYNAMIC_DEBUG=y and mount debugfs, after that:
> # echo module e1000e +p > /sys/kernel/debug/dynamic_debug/control
> If it would be too verbose you can enable these messages more selective.

I have CONFIG_DYNAMIC_DEBUG=y, but the issue is pretty hard to
reproduce. As soon as it recurs, I will report the results of the above...

thanks,
-- 
js
suse labs
