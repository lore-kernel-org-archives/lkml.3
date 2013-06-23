Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729Ab3FWVlZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 17:41:25 -0400
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:57753 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab3FWVlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 17:41:23 -0400
X-Greylist: delayed 809 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Jun 2013 17:41:23 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=sasl; b=Z92s+/
	U03ZmwpFY5ANCM52/QYZIoZuwPZdM0+HjYgyeOXNjfZYL73ctnP2bsghPwl751CQ
	L3kFYAI+6yTI/0yq9o2TGoRhf7MleUMF9gIAPG0dWBn+biiQBYRziUxx1FeY4+0o
	fDmOLexBDljkkry/kfLFc7XRkdvhAm82l11dM=
Message-ID: <51C76858.4060906@pobox.com>
Date: Sun, 23 Jun 2013 17:27:52 -0400
From: Mark Lord <mlord@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Marcus Overhagen <marcus.overhagen@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
        tj@kernel.org
Subject: Re: SATA hdd refuses to reallocate a sector?
References: <20130623101940.GA4448@amd.pavel.ucw.cz> <20130623112133.GA4837@amd.pavel.ucw.cz> <CAJBHPoj5hgp97=JH8UKX+Ty8TF9_ySQUYU6AnqcRjuLy5A-PcQ@mail.gmail.com> <20130623190003.GA6714@amd.pavel.ucw.cz>
In-Reply-To: <20130623190003.GA6714@amd.pavel.ucw.cz>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: C36A258C-DC4B-11E2-9BD8-D5430E5B5709-82205200!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-06-23 03:00 PM, Pavel Machek wrote:
>
> Thanks for the hint. (Insert rant about hdparm documentation
> explaining that it is bad idea, but not telling me _why_ is it bad
> idea. Can I expect cache consistency issues after that, or is it just
> simple "you are writing to the disk without any checks"? Plus, I guess
> documentation should mention what sector number is. I guess sectors
> are 512bytes for the old drives, but is it 512 or 4096 for new
> drives?)

For ATA, use the "logical sector size".
For all existing drives out there, that's a 512 byte unit.

> ...but it does not do the trick :-(. It behaves strangely as if it was
> still cached somewhere. Do I need to turn off the write back cache?

No, it works just fine.  You probably have more than one bad sector.
After you see a read failure, run "smartctl -a" and look at the error
logs to see what sector the drive is choking on.

Or just low-level format it all with "hdparm --security-erase".

Cheers
-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
