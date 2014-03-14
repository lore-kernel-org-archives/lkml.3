Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322AbaCNRRP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 13:17:15 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:40277 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975AbaCNRRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 13:17:13 -0400
Message-ID: <1394817430.31499.216.camel@bobble.lax.corp.google.com>
Subject: Re: [PATCH] block:  Force sector and nr_sects to device alignment
 and granularity.
From: Frank Mayhar <fmayhar@google.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Theodore Tso <tytso@google.com>
Date: Fri, 14 Mar 2014 10:17:10 -0700
In-Reply-To: <yq1d2hq27jk.fsf@sermon.lab.mkp.net>
References: <1394474492.31499.177.camel@bobble.lax.corp.google.com>
	 <x49wqg0bwb4.fsf@segfault.boston.devel.redhat.com>
	 <1394553778.31499.180.camel@bobble.lax.corp.google.com>
	 <x491ty71dox.fsf@segfault.boston.devel.redhat.com>
	 <yq1d2hq27jk.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-12 at 21:47 -0400, Martin K. Petersen wrote:
> I'm no big fan of dropping information.
> 
> My original intent with the discard granularity and alignment was to
> allow filesystems to use them to influence block allocation and layout.
> Not to affect how we issue commands at runtime.
> 
> Since a storage device is free to ignore all or parts of any discard
> request I'd consider it somewhat broken if it actually complained.
> Especially so since the relevant knobs in the standard that we key off
> of are performance recommendations and not requirements that commands
> must adhere to.

Well, in this particular case the driver is filling in the relevant
information (alignment and granularity) and then complaining later that
that information has been ignored.  As I intimated earlier, it seems a
little odd to allow the driver to specify the information, only to
ignore it completely when it's time to actually use it.

Further, in my opinion this is less "dropping information" than it is
keeping information that would be dropped by the driver itself; were it
not for this adjustment, the driver would get the request, complain, and
drop it completely.  This way, as much of the request as possible is
preserved while still honoring the constraints given by the driver.
-- 
Frank Mayhar
310-460-4042

