Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab3FWWfs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 18:35:48 -0400
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:38696 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab3FWWfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 18:35:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=sasl; b=LzfyP7
	hSJXENmpGfn/ylD6I/+pn8xXOqNR4rQ4b1OwtdsvkjxrfCclYzFuha1v9g73E3lc
	OCRcAQJvuSyIlZS8VPi8rIr9gKlZ6w6MJjiGCMkhBHhEnWGTILzQOk455/q+r65q
	6f8wmsOBgNK3zpmVELPBnN8Z8te54qhgeeQ0w=
Message-ID: <51C77840.2060800@pobox.com>
Date: Sun, 23 Jun 2013 18:35:44 -0400
From: Mark Lord <mlord@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Marcus Overhagen <marcus.overhagen@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
        tj@kernel.org
Subject: Re: SATA hdd refuses to reallocate a sector?
References: <20130623101940.GA4448@amd.pavel.ucw.cz> <20130623112133.GA4837@amd.pavel.ucw.cz> <CAJBHPoj5hgp97=JH8UKX+Ty8TF9_ySQUYU6AnqcRjuLy5A-PcQ@mail.gmail.com> <20130623190003.GA6714@amd.pavel.ucw.cz> <51C76858.4060906@pobox.com> <20130623215100.GA7414@amd.pavel.ucw.cz>
In-Reply-To: <20130623215100.GA7414@amd.pavel.ucw.cz>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 3E94C68C-DC55-11E2-8424-D5430E5B5709-82205200!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-06-23 05:51 PM, Pavel Machek wrote:
> On Sun 2013-06-23 17:27:52, Mark Lord wrote:
>
>> For all existing drives out there, that's a 512 byte unit.
> 
> I guessed so. (It would be good to actually document it, as well as
> documenting exactly why it is dangerous. Is it okay to send patches?)

Absolutely.  Please, even!

> Well, I definitely have more than one bad sector, but I did try to
> read exactly the same sector and it failed. See below.
..
read failed.
write works.
read failed.
write works.
read works.
dd failed.
read works.
read works.
read failed.

Odd.  The drive must be furiously reshuffling sectors or something,
or more likely pushing a piece of dirt around scuffing up more bits.

hdparm generally talks directly to a drive, not through the block
or filesystem layers.  So the block, filesystem, and page-cache stuff
don't know anything about --read-sector and --write-sector.

Cheers
-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
