Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab3D3Gpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 02:45:35 -0400
Received: from smtp2.macqel.be ([194.78.208.39]:12623 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753037Ab3D3Gpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 02:45:34 -0400
Date: Tue, 30 Apr 2013 08:45:30 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: Jens Axboe <axboe@kernel.dk>
Cc: Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] Add aix lvm partitions support files
Message-ID: <20130430064530.GA2036@frolo.macqel>
References: <1366924229-21569-1-git-send-email-phdm@macqel.be> <1366924229-21569-3-git-send-email-phdm@macqel.be> <20130429093756.GB12317@x2.net.home> <20130429114041.GA10884@frolo.macqel> <20130429123651.GA2400@x2.net.home> <20130429153450.GA25581@frolo.macqel> <20130430064152.GK9563@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130430064152.GK9563@kernel.dk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 08:41:52AM +0200, Jens Axboe wrote:
> On Mon, Apr 29 2013, Philippe De Muyter wrote:
> > 
> > so sda is 8,0 and sdb is 8,16
> > 
> > and if, while discovering partitions of /dev/sda, I try to make a
> > partition 16 or higher, it is silently discarded by 'put_partition'.
> > 
> > Is that changed ?
> 
> That's a set limitation of sd, it does not apply to other devices. The
> legacy IDE code used 64 for max partitions, for instance. So Karel is
> right, you should not make any assumptions about the max number of
> partitions, it is driver dependent.

I replaced that by state->limit in the v2 series.

Philippe
