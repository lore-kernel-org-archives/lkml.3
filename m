Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896AbaHGQnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 12:43:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39751 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932500AbaHGQnU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 12:43:20 -0400
Date: Thu, 7 Aug 2014 18:43:16 +0200
From: Jean Delvare <jdelvare@suse.de>
To: kreijack@inwind.it
Cc: Goffredo Baroncelli <kreijack@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] Add the "verbose" module option.
Message-ID: <20140807184316.6682aa98@endymion.delvare>
In-Reply-To: <53E3A963.4080807@inwind.it>
References: <1407359103-6012-1-git-send-email-kreijack@inwind.it>
	<1407359103-6012-4-git-send-email-kreijack@inwind.it>
	<1407401555.4314.14.camel@chaos.site>
	<53E3A963.4080807@inwind.it>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Aug 2014 18:29:23 +0200, Goffredo Baroncelli wrote:
> On 08/07/2014 10:52 AM, Jean Delvare wrote:
> > Le Wednesday 06 August 2014 à 21:05 +0000, Goffredo Baroncelli a écrit :
> >> +	 */
> >> +	tempchanged = x.temp != temp || x.casetemp != casetemp;
> >> +	if ((verbose > 1 && tempchanged) ||
> >> +	    (verbose > 0 && level >= 0)) {
> >> +		printk(KERN_INFO);
> >> +		print_temp("CPU-temp: ", temp);
> > 
> > This can be written more efficiently as a single statement:
> > 
> > 		print_temp(KERN_INFO "CPU-temp: ", temp);
> 
> I suppose that KERN_* has to be in the beginning of the line. 

Correct.

> Because a single line is composed by several prink,

In this case, it is, but FYI, this is generally discouraged. The reason
is that another piece of the kernel may be calling printk at the same
time, and then that other message may split your own message into
pieces. If you run checkpatch.pl on this file, you'll see it complains
about this.

> KERN_INFO has 
> to be only in the first printk. To me it seems more polite to have
> one printk for the level, and the others (there are more than one) 
> for the message parts.

The fewer printks is better. Ideally there would be only one to avoid
the risk of line splitting altogether. I understand this isn't easy to
achieve in this case, but I still believe that you shouldn't have more
calls to printk than necessary, to reduce the risk.

-- 
Jean Delvare
SUSE L3 Support
