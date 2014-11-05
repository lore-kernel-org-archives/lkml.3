Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306AbaKEWOY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 17:14:24 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:54543 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751110AbaKEWOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 17:14:21 -0500
Message-ID: <545AA139.9040207@hurleysoftware.com>
Date: Wed, 05 Nov 2014 17:14:17 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 3/4] PNP: Allow device to override ACPI device sleep
References: <1415212854-16944-1-git-send-email-peter@hurleysoftware.com> <1415212854-16944-4-git-send-email-peter@hurleysoftware.com> <4057911.0dclCWmemA@vostro.rjw.lan>
In-Reply-To: <4057911.0dclCWmemA@vostro.rjw.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2014 05:28 PM, Rafael J. Wysocki wrote:
> On Wednesday, November 05, 2014 01:40:53 PM Peter Hurley wrote:
>> If the serial console is an ACPI PNP device, the PNP bus attempts to
>> power-down the device, even though the no_console_suspend command line
>> parameter is specified (eg., debugging suspend/resume).
>>
>> Add PNP_SUSPEND capability which is on by default, but when cleared,
>> prevents pnpacpi_suspend() (which is the ACPI PNP protocol ->suspend()
>> method).
>>
>> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> 
> While I'm not disagreeing with this entirely, I have a concern.
> 
> There are two types of suspend in Linux these days, runtime suspend and
> system suspend.  What this is about is "device suspend during system
> suspend" only, so the flag name is somewhat confusing.

Yeah, I see your point. I wouldn't want people thinking this had anything
to do with runtime pm.

> Also the flag is only going to be used for consoles, so why don't you
> introduce a PNP_CONSOLE flag and then define pnp_can_suspend() as
> 
> static inline pnp_can_suspend(struct pnp_dev *pnp_dev)
> {
> 	return pnp_dev->protocol->suspend &&
> 		 (!(pnp_dev->capabilities & PNP_CONSOLE) || console_suspend_enabled);
> }

I can do that.

Regards,
Peter Hurley
