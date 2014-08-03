Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaHCPw2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 11:52:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48009 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965AbaHCPw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 11:52:27 -0400
Date: Sun, 3 Aug 2014 17:52:22 +0200
From: Jean Delvare <jdelvare@suse.de>
To: kreijack@inwind.it
Cc: kreijack@gmail.com, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, bryan@whatroute.net
Subject: Re: [PATCH 3/4] Add the "verbose" module option.
Message-ID: <20140803175222.3433b646@endymion.delvare>
In-Reply-To: <53DE5179.3080402@gmail.com>
References: <1406901650-20841-1-git-send-email-kreijack@inwind.it>
	<1406901650-20841-4-git-send-email-kreijack@inwind.it>
	<20140803161223.0b26e4bc@endymion.delvare>
	<53DE5179.3080402@gmail.com>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 03 Aug 2014 17:12:57 +0200, Goffredo Baroncelli wrote:
> On 08/03/2014 04:12 PM, Jean Delvare wrote:
> >> +	    (verbose > 0 && level >= 0)) {
> >> +		print_temp("CPU-temp: ", temp );
> >> +		if (casetemp)
> >> +			print_temp(", Case: ", casetemp );
> >> +		if (level >= 0)
> >> +			printk(", Fan: %d (tuned %+d)\n", 11-level,
> >> +				x.fan_level-level );
> >> +		else
> >> +			printk(", Fan: %d (tuned +0)\n",x.fan_level);
> > 
> > I think you can do without the "tuned +0" which doesn't add much value.
> 
> Me too. But the old driver does the same, so I preferred to 
> leave it as is.

I looked at the code again and no, I can't see the old code doing that.
It has "tuned %+d" only in tune_fan() which is only called if
level >= 0. The other printk (when tune_fan isn't called) doesn't have
a "tuned" part.

-- 
Jean Delvare
SUSE L3 Support
