Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab3LTVNa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 16:13:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48018 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514Ab3LTVN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 16:13:28 -0500
Message-ID: <52B4B2D4.2020305@zytor.com>
Date: Fri, 20 Dec 2013 13:12:52 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: "samer.el-haj-mahmoud@hp.com" <samer.el-haj-mahmoud@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jlee@suse.com" <jlee@suse.com>, "bp@suse.de" <bp@suse.de>,
        "a.zummo@towertech.it" <a.zummo@towertech.it>,
        "Elliott@hp.com" <Elliott@hp.com>, "werner@suse.com" <werner@suse.com>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "oneukum@suse.de" <oneukum@suse.de>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "trenn@suse.de" <trenn@suse.de>,
        "JBeulich@suse.com" <JBeulich@suse.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "matt@console-pimps.org" <matt@console-pimps.org>
Subject: Re: [RFC PATCH 00/14] Support timezone of ACPI TAD and EFI TIME
References: <1387439053-8711-1-git-send-email-jlee@suse.com>	 <52B309EB.90300@zytor.com> <1387512357.3539.4317.camel@linux-s257.site>	 <52B3C5F0.1060303@zytor.com> <1387552565.17961.3.camel@x230>
In-Reply-To: <1387552565.17961.3.camel@x230>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2013 07:16 AM, Matthew Garrett wrote:
> On Thu, 2013-12-19 at 20:22 -0800, H. Peter Anvin wrote:
>> On 12/19/2013 08:05 PM, joeyli wrote:
>>> Can we use EFI time services on x86_64 after Borislav's patches accepted
>>> to mainline?
>>>
>>
>> No.
> 
> We will want to use them to (at minimum) obtain the clock timezone.
> Using them for general RTC access is less attractive.
> 

One option is to use the EFI runtime call to get and save the clock
timezone before we call ExitBootServices() in the EFI stub.  This
doesn't obviate the need for proper handling of the TAD, though,
especially since it is likely that future hardware will not have a RTC
in the current form (it is a way more complex device than is needed,
which wouldn't normally be a problem, but the fact that it has to
operate in the Vbat well makes it a major one.)

	-hpa

