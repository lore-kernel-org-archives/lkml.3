Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab3JJTsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 15:48:32 -0400
Received: from imap.thunk.org ([74.207.234.97]:44633 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756197Ab3JJTsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 15:48:31 -0400
Date: Thu, 10 Oct 2013 15:48:24 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Clemens Ladisch <clemens@ladisch.de>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: rngd
Message-ID: <20131010194824.GB32527@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Clemens Ladisch <clemens@ladisch.de>, linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <1380811955-18085-1-git-send-email-svarbanov@mm-sol.com>
 <20131003165130.GA11974@thunk.org>
 <524EEB96.6040707@mm-sol.com>
 <20131004181005.GA7022@thunk.org>
 <52556C4E.9000604@mm-sol.com>
 <52557137.5050200@zytor.com>
 <20131009160338.GD1198@thunk.org>
 <52558320.9090603@zytor.com>
 <52565B56.1070606@ladisch.de>
 <5256C2F9.8090707@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5256C2F9.8090707@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 08:08:41AM -0700, H. Peter Anvin wrote:
> 
> Mainly the maintainer isn't merging in fixes from upstream, apparently
> because he has misunderstood their function.

>From the README file from the Debian fork:

rng-tools unofficial-mt is a living reminder to myself to not modify upstream
code without sending the changes upstream at every step.  Suddenly, you have a
mass of changes too big to send upstream, and yet you find yourself without the
energy to break them into smallish patches to submit upstream (i.e. to
"unfork").

> > What I'm trying to say with all this is that self-tests must be
> > customized for each entropy source.
> 
> Yes.  I don't think the FIPS tests make any sense at all (up to and
> including rngd 3 they would eventually kill rngd, because it only
> allowed for a fixed number of false positives.)

... and to the extent that output is crypto-whitened in the hardware,
with no way of disabling the whitening, it's actually kind of hopeless
to do any kind of testing.

One of the reasons why I wanted to keep this functionality in
userspace, as opposed to moving this into a kernel thread, is because
I was hoping someone would create hardware which did not do hardware
whitening, and userspace could do proper quality checking of the
entropy source, and data reduction as necessary, all in the an open
and auditable way.  If we are doing the those more heavyweight tests,
it's not a clear it makes sense to put all of this in the kernel.

     	   	    	  	       - Ted
