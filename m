Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759876Ab3BZT3B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 14:29:01 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:62734 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757815Ab3BZT27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 14:28:59 -0500
MIME-Version: 1.0
In-Reply-To: <CAB=NE6WAKjktv8G1eikkfkbB7KAa_XefJj-udfH8b_vvgLbznQ@mail.gmail.com>
References: <1361648055-15871-1-git-send-email-kazikcz@gmail.com>
	<CAB=NE6WAKjktv8G1eikkfkbB7KAa_XefJj-udfH8b_vvgLbznQ@mail.gmail.com>
Date: Tue, 26 Feb 2013 20:28:58 +0100
Message-ID: <CABvG-CW+ykoZMz49UNS11=rLViNQ3uyo-sHeJqOdp06Vwd628g@mail.gmail.com>
Subject: Re: [PATCH] ath: sanitize 0xFFFF regdomain
From: =?UTF-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: David Quan <dquan@qca.qualcomm.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 February 2013 19:29, Luis R. Rodriguez <mcgrof@qca.qualcomm.com> wrote:
> NACK. This comes up every now and then and this is not a valid device
> ID, this is an issue with the card, so what you can do is adjust the
> device ID post bootup. Not sure if distros have an easy way to set
> this up, if not perhaps this should be considered as this has come up
> twice before.

The erroneous 0xFFFF value comes from using one of eeprom_ops
implementations. Do you suggest I should fool ath regd code to think
this is a different card so it picks a different (perhaps correct, if
at all) eeprom_ops variant? How do I do that?

>From what I can tell this is in the pci probing and I can't see any
way to skip the regd initialisation. I don't see how current_rd can
have a value other than 0xFFFF for this device in this code path.

Or am I missing something?


-- Michal.
