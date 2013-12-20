Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab3LTEV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 23:21:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39391 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838Ab3LTEV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 23:21:57 -0500
Message-ID: <52B3C5A6.3070805@zytor.com>
Date: Thu, 19 Dec 2013 20:20:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: joeyli <jlee@suse.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com,
        samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>,
        werner@suse.com, trenn@suse.de, JBeulich@suse.com,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        x86@kernel.org,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 03/14] rtc: block registration of rtc-cmos when CMOS RTC
 Not Present
References: <1387439053-8711-1-git-send-email-jlee@suse.com>	 <1387439053-8711-4-git-send-email-jlee@suse.com>	 <6fc9a2f9-eae7-4588-a092-f338053ec96a@email.android.com> <1387511650.3539.4294.camel@linux-s257.site>
In-Reply-To: <1387511650.3539.4294.camel@linux-s257.site>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 07:54 PM, joeyli wrote:
> Hi hpa, 
> 
> 於 四，2013-12-19 於 06:38 -0800，H. Peter Anvin 提到：
>> Where did you find a platform with "no CMOS" set and a PNP RTC? I find the expect behavior in that case to be quite ambiguous and it is not at all clear to me that what you have here is the right thing.
> 
> Actually there doesn't have the box both with "No CMOS" and PNP device. 
> I choice to totally block rtc-cmos driver when "No CMOS RTC" because the
> definition in ACPI spec:
> 
> CMOS RTC Not Present
> 
> If set, indicates that the CMOS RTC is either not implemented, or
> does not exist at the legacy addresses. OSPM uses the Control
> Method Time and Alarm Namespace device instead.
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> It suggest us using ACPI TAD interface when this flag present. But, I
> agreed your point for this is ambiguous due to ACPI spec didn't clear
> define the relationship between PNP0B0x.
> 
> Maybe we can do more detail check in cmos_init when "No CMOS RTC" set:
>  + check if have ACPI TAD device, then block rtc-cmos
>  + check if no ACPI TAD device, but have PNP0B0x, then we use PNP0b0x.
> 

I think the only thing we should use that bit for is to inhibit the
last-resort probing of I/O ports 0x70-0x73... if at all.

	-hpa


