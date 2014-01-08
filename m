Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbaAHP0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 10:26:15 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:60416 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301AbaAHP0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 10:26:13 -0500
Date: Wed, 8 Jan 2014 07:26:10 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Sergey Meirovich <rathamahata@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gluk <git.user@gmail.com>
Subject: Re: Terrible performance of sequential O_DIRECT 4k writes in SAN
 environment. ~3 times slower then Solars 10 with the same HBA/Storage.
Message-ID: <20140108152610.GA5863@infradead.org>
References: <CA+QCeVQRrqx=CrxyuAe7k0e0y4Nqo7x_8jtkuD99VM8L9Dxp+g@mail.gmail.com>
 <20140106201032.GA13491@quack.suse.cz>
 <20140107155830.GA28395@infradead.org>
 <CA+QCeVRiwHU+C5utaLQXf_MpjoYMYEF4LKRyDPaqcd=H6n-RRw@mail.gmail.com>
 <20140108140307.GA588@infradead.org>
 <CA+QCeVQy08m9oBM1ULE_KAjd-36ao35p7-BCWErJewyr3m6NGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+QCeVQy08m9oBM1ULE_KAjd-36ao35p7-BCWErJewyr3m6NGg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 04:43:07PM +0200, Sergey Meirovich wrote:
> Results are almost the same:
>     14.68Mb/sec  3758.02 Requests/sec
>

On my laptop SSD I get the following results (sometimes up to 200MB/s,
sometimes down to 100MB/s, always in the 40k to 50k IOps range):

time elapsed (sec.):	5
bandwidth (MiB/s):	160.00
IOps:			40960.00

The IOps are more than the hardware is physically capable of, but given
that you didn't specify O_SYNC this seems sensible given that we never
have to flush the disk cache.

Could it be that your array has WCE=0?  In Linux we'll never enable the
cache automatically, but Solaris does at least when using ZFS.  Try
running:

   sdparm --set=WCE /dev/sdX

and try again.
