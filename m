Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbaJJMxG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 08:53:06 -0400
Received: from dovecot.logic.tuwien.ac.at ([128.130.175.61]:43016 "EHLO
	mail.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989AbaJJMxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 08:53:00 -0400
Date: Fri, 10 Oct 2014 21:52:57 +0900
From: Norbert Preining <preining@logic.at>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org
Subject: Re: /dev/root changes with 3.17-rc
Message-ID: <20141010125257.GJ11697@auth.logic.tuwien.ac.at>
References: <20140911144510.GK22037@auth.logic.tuwien.ac.at>
 <20141010124012.GA27653@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141010124012.GA27653@amd>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2014, Pavel Machek wrote:
> > I am not sure whether this is a kernel bug, but:
> > - booting with 3.16 I get
> > 	/ mounted on /dev/sda6
> > - booting with 3.17-rc* I get
> > 	/ mounted on /dev/root
> 
> Where do you see the this? /proc/mounts?

After loads of testing I found out what is the problem: initramfs.

I normally compile my own kernel with all the drivers built-in,
and no initramfs ... and in this case, without initrd, it seems that
/ is somehow not remounted to a proper scsi device, but remains 
at /dev/root.

Hope that helps

Norbert

------------------------------------------------------------------------
PREINING, Norbert                               http://www.preining.info
JAIST, Japan                                 TeX Live & Debian Developer
GPG: 0x860CDC13   fp: F7D8 A928 26E3 16A1 9FA0  ACF0 6CAC A448 860C DC13
------------------------------------------------------------------------
