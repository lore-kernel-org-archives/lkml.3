Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbaDAUrl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 16:47:41 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43756 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbaDAUrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 16:47:40 -0400
Message-ID: <533B25E8.8040201@wwwdotorg.org>
Date: Tue, 01 Apr 2014 14:47:36 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: stefan@agner.ch, chris@printf.net, linux-mmc@vger.kernel.org
CC: linux-tegra@vger.kernel.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/2] mmc: use SD/MMC host ID for block device name ID
References: <cover.1396384101.git.stefan@agner.ch> <2f6ac51155f9d34791b274b5102d15a997ff8b99.1396384101.git.stefan@agner.ch>
In-Reply-To: <2f6ac51155f9d34791b274b5102d15a997ff8b99.1396384101.git.stefan@agner.ch>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2014 02:35 PM, stefan@agner.ch wrote:
> From: Stefan Agner <stefan@agner.ch>
> 
> By using the SD/MMC host device ID as a starting point for block
> device numbering, one can reliably predict the first block device
> name (at least for the first controller).

That's not true. There's no guarantee that a device name/ID gets
released as soon as the SD card is removed; something might still have
it mounted for example.

The correct solution here is to use filesystem or partition UUIDs to
identify the device/partition, not to attempt to assign static device IDs.
