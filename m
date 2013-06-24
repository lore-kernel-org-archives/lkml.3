Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab3FXMSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 08:18:37 -0400
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:43607 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab3FXMSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 08:18:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=sasl; b=O1qK1Z
	1g5kg+jKrsHnxbe9s7I/DS+DTgP3aGZ/6f8L5Tn/91NvZBi1RI00qRwYuwfaoOpy
	c60gYBRITSYqJOYhhNz/OxvocfkWzeOy0zm/D2ClrrLTDpNb3KmDNqqtPpZAYG+1
	vv0HgyhC4NnjPCjb+QzSkJb4Tv+cFEPG7Io1U=
Message-ID: <51C83907.2020202@pobox.com>
Date: Mon, 24 Jun 2013 08:18:15 -0400
From: Mark Lord <mlord@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: Pavel Machek <pavel@ucw.cz>, Marcus Overhagen <marcus.overhagen@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
        tj@kernel.org
Subject: Re: SATA hdd refuses to reallocate a sector?
References: <20130623101940.GA4448@amd.pavel.ucw.cz> <51C76858.4060906@pobox.com> <20130623215100.GA7414@amd.pavel.ucw.cz> <201306240914.29502.linux@rainbow-software.org>
In-Reply-To: <201306240914.29502.linux@rainbow-software.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 27287372-DCC8-11E2-9DD3-D5430E5B5709-82205200!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-06-24 03:14 AM, Ondrej Zary wrote:
..
> Being tired of using hdparm manually, I created a simple hdd_realloc utility
> that reads the disk in big blocks (1 MB). When there's a read error, it reads
> the failed block sector-by-sector and tries to rewrite the sectors that fail
> to read. It work fine for disks with just a couple of pending sectors.

Something like that would work very well if it used the hdparm approach
(directly to the drive) for the sector-by-sector part.

Going through the block layer isn't always going to work,
because the kernel likes to do I/O in PAGE_SIZE multiples.

And the SCSI stack in Linux has rather atrocious error handling.
It lumps multiple requests together, and can fail the entire lot even
if only a single sector is bad.

Cheers
-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
