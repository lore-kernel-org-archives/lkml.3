Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbaFYIGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 04:06:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60799 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178AbaFYIGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 04:06:07 -0400
Date: Wed, 25 Jun 2014 10:06:05 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, tiwai@suse.de,
        chunkeey@googlemail.com, leedom@chelsio.com, cocci@systeme.lip6.fr,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] p54: use request_firmware_direct() for optional
	EEPROM override
Message-ID: <20140625080605.GN27687@wotan.suse.de>
References: <1403649583-12707-1-git-send-email-mcgrof@do-not-panic.com> <1403649583-12707-4-git-send-email-mcgrof@do-not-panic.com> <53AA799F.7030807@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53AA799F.7030807@broadcom.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 09:26:23AM +0200, Arend van Spriel wrote:
> On 25-06-14 00:39, Luis R. Rodriguez wrote:
>> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>>
>> The p54 driver uses request_firmware() twice, once for actual
>> firmware and then another time for an optional user overide on
>> EEPROM, 3826.eeprom. The custom EEPROM  is optional but if not
>> present we'll introduce an extra lag of 60 seconds with udev
>> present. Annotate we don't want udev nonsense here to avoid
>> the lag in case its not present.
>
> I guess the fact that EEPROM is optional does not matter much. If doing a 
> second request you could always use request_firmware_direct(), right?

The better way to rephrase this from a technical perspective is:

I don't care about udev firmware upload as it'll be removed, and its only
adding 60 second delays. I *know* this driver doesn't require custom paths and
wierd user upload tools so lets evolve a few light years ahead and embrace
non-udev Direct upload for at least optional juju config data.

  Luis
