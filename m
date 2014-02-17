Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbaBQRTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 12:19:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59803 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847AbaBQRTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 12:19:36 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <3121313.GKMnFpiL5h@skinner>
References: <4729ad4b8d3342c1b0e29fefe4b04d6a@DB4PR04MB265.eurprd04.prod.outlook.com> <52FE7738.6040009@zytor.com> <alpine.DEB.2.02.1402142140430.21991@ionos.tec.linutronix.de> <3121313.GKMnFpiL5h@skinner>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: AW: AW: [PATCH] x86: HPET force enable for Soekris net6501
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 17 Feb 2014 09:19:03 -0800
To: Thomas Renninger <trenn@suse.de>, Thomas Gleixner <tglx@linutronix.de>
CC: Conrad Kostecki <ck@conrad-kostecki.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Message-ID: <09d1230f-a261-4858-a390-72df138aaa34@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What I gather is that they want to add tables where there are none, and that the ACPI code doesn't play along because there is no RSDP nor any RSDT/XSDT.

On February 17, 2014 8:28:05 AM PST, Thomas Renninger <trenn@suse.de> wrote:
>On Friday, February 14, 2014 10:16:41 PM Thomas Gleixner wrote:
>> On Fri, 14 Feb 2014, H. Peter Anvin wrote:
>> > On 02/14/2014 11:59 AM, Thomas Gleixner wrote:
>> > > On Fri, 14 Feb 2014, H. Peter Anvin wrote:
>> > >> On 02/14/2014 11:15 AM, Thomas Gleixner wrote:
>> > >>> I'm fine with ACPI tables if we can provide simple means for
>embedded
>> > >>> users to load one via grub or just attach it to the kernel
>image.
>> > >> 
>> > >> That already exists, see
>Documentation/acpi/initrd_table_override.txt.
>> > > 
>> > > That requires, that you have already ACPI tables.
>> > > 
>> > > ACPI_SIG_RSDP cannot be overridden and that's the base table you
>need
>> > > to get ACPI going in the first place. So we need support for that
>and
>> > > probably for storing the tables at some non canonical place.
>> > 
>> > Well, the RSDP and RSDT/XSDT are nothing but pointers to other
>tables,
>> > so if explicitly overridden I'm not sure if one actually would need
>> > them.  That doesn't mean our current code will work without them,
>though.
>> 
>> I tried once to overload all of the tables, but failed miserably in
>> the ACPI dungeon. RSDP was the major pain point IIRC.
>
>What exactly do you try to achieve?
>I cannot imagine a use-case where RSDP  and XSDT overriding would help
>you.
>
>Have you tried the current mechanism to override tables?
>What is missing and for what do you need it for?
>
>I need more context, maybe I can help then.
>
>   Thomas

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
