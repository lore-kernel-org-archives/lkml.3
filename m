Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab3LTJQf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 04:16:35 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:54585 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab3LTJQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 04:16:31 -0500
X-Originating-IP: 50.43.14.201
Date: Fri, 20 Dec 2013 01:16:21 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: Ravi Patel <rapatel@apm.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andy Whitcroft <apw@canonical.com>, Kumar Sankaran <ksankaran@apm.com>,
        Loc Ho <lho@apm.com>, Keyur Chudgar <kchudgar@apm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch.pl error might be false positive
Message-ID: <20131220091621.GC21784@leaf>
References: <CAN1v_PvS3dH6HVQ90d=3cfsSdMgieyoDNp3VN-vrHv-aqSFEAw@mail.gmail.com>
 <1387491348.2353.20.camel@joe-AO722>
 <20131220075634.GA21784@leaf>
 <1387528630.2353.39.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387528630.2353.39.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 12:37:10AM -0800, Joe Perches wrote:
> On Thu, 2013-12-19 at 23:56 -0800, Josh Triplett wrote:
> > On Thu, Dec 19, 2013 at 02:15:48PM -0800, Joe Perches wrote:
> > > On Thu, 2013-12-19 at 13:01 -0800, Ravi Patel wrote:
> > > > My name is Ravi Patel and I am working for AppliedMicro.
> > > > I am planning to submit APM X-Gene SoC QMTM drivers to open source after
> > > > running checkpatch.pl
> > > > I am seeing following error saying remove FSF address from my patch, which
> > > > I don't have in my source/header files.
> > > > 
> > > > ERROR: Do not include the paragraph about writing to the Free Software
> > > > Foundation's mailing address from the sample GPL notice. The FSF has
> > > > changed addresses in the past, and may do so again. Linux already includes
> > > > a copy of the GPL.
> > > > #1580: FILE: include/misc/xgene/xgene_qmtm.h:19:
> > > > + * You should have received a copy of the GNU General Public License$
> > > > 
> > > > Here is my License banner in xgene_qmtm.h
> > > > There are no tabs in my banner
> > > > 
> > > > /*
> > > >  * AppliedMicro X-Gene SOC Queue Manager/Traffic Manager driver
> > > >  *
> > > >  * Copyright (c) 2013 Applied Micro Circuits Corporation.
> > > >  * Author: Ravi Patel <rapatel@apm.com>
> > > >  *         Keyur Chudgar <kchudgar@apm.com>
> > > >  *         Fushen Chen <fchen@apm.com>
> > > >  *
> > > >  * This program is free software; you can redistribute  it and/or modify it
> > > >  * under  the terms of  the GNU General  Public License as published by the
> > > >  * Free Software Foundation;  either version 2 of the  License, or (at your
> > > >  * option) any later version.
> > > >  *
> > > >  * This program is distributed in the hope that it will be useful,
> > > >  * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > >  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > >  * GNU General Public License for more details.
> > > >  *
> > > >  * You should have received a copy of the GNU General Public License
> > > >  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> > > >  *
> > > >  */
> > > > 
> > > > Can you please check if the error is false positive.
> > > 
> > > Josh?
> > > 
> > > Is the intent that the "copy of the GNU General Public License"
> > > statement should also be removed?
> > 
> > While it does seem preferable to drop that paragraph, it isn't nearly as
> > important as dropping the mailing address.  The match on "You should
> > have received a copy" should probably be reduced to CHK level or
> > dropped.
> 
> Maybe something like this, but maybe dropping the
> "you should have received a copy" is ok too.
> 
> I did a few greps for various address patterns and
> it seems using case insensitive matches and shorter
> street types is better.
> 
> There are a few places where number and street name
> are on different lines.  Oh well, nothing's perfect.

Duplicating the regex seems awful.  Could you put it in a variable?

> ---
>  scripts/checkpatch.pl | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 8f3aecd..b02d6ad 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1963,15 +1963,16 @@ sub process {
>  		}
>  
>  # Check for FSF mailing addresses.
> -		if ($rawline =~ /You should have received a copy/ ||
> -		    $rawline =~ /write to the Free Software/ ||
> -		    $rawline =~ /59 Temple Place/ ||
> -		    $rawline =~ /51 Franklin Street/) {
> +		if ($rawline =~ /\bYou should have received a copy/i ||
> +		    $rawline =~ /\bwrite to the Free/i ||
> +		    $rawline =~ /\b59\s+Temple\s+Pl/i ||
> +		    $rawline =~ /\b51\s+Franklin\s+St/i) {
>  			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
>  			my $msg_type = \&ERROR;
>  			$msg_type = \&CHK if ($file);
> +			$msg_type = \&CHK if ($rawline =~ /\bYou should have received a copy/i);
>  			&{$msg_type}("FSF_MAILING_ADDRESS",
> -				"Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so again. Linux already includes a copy of the GPL.\n" . $herevet)
> +				     "Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so again. Linux already includes a copy of the GPL.\n" . $herevet)
>  		}
>  
>  # check for Kconfig help text having a real description
> 
> 
