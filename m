Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759812Ab3BZSaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 13:30:07 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:54191 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097Ab3BZSaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 13:30:05 -0500
MIME-Version: 1.0
In-Reply-To: <1361648055-15871-1-git-send-email-kazikcz@gmail.com>
References: <1361648055-15871-1-git-send-email-kazikcz@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Tue, 26 Feb 2013 10:29:43 -0800
X-Google-Sender-Auth: KvCB33jyTthQAxplu9u_HxRSI30
Message-ID: <CAB=NE6WAKjktv8G1eikkfkbB7KAa_XefJj-udfH8b_vvgLbznQ@mail.gmail.com>
Subject: Re: [PATCH] ath: sanitize 0xFFFF regdomain
To: Michal Kazior <kazikcz@gmail.com>, David Quan <dquan@qca.qualcomm.com>,
        linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2013 at 11:34 AM, Michal Kazior <kazikcz@gmail.com> wrote:
> Dbii F52N-PRO mini pci device reports an invalid
> regdomain. This card has been reported to work on
> MikroTik's RouterOS but failed on Linux:
>
> [   14.320000] ath: EEPROM regdomain: 0xffff
> [   14.320000] ath: EEPROM indicates we should expect a country code
> [   14.320000] ath: invalid regulatory domain/country code 0xbfff
> [   14.320000] ath: Invalid EEPROM contents
> [   14.320000] ath9k 0000:00:12.0: Failed to initialize device
> [   14.330000] ath9k: probe of 0000:00:12.0 failed with error -22
>
> With the patch the device works fine.
>
> Signed-off-by: Michal Kazior <kazikcz@gmail.com>

NACK. This comes up every now and then and this is not a valid device
ID, this is an issue with the card, so what you can do is adjust the
device ID post bootup. Not sure if distros have an easy way to set
this up, if not perhaps this should be considered as this has come up
twice before.

  Luis
