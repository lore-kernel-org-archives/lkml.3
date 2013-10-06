Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab3JFTTT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 15:19:19 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:37027 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316Ab3JFTTS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 15:19:18 -0400
Date: Sun, 06 Oct 2013 14:19:14 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] checkpatch.pl: Check for the FSF mailing address
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
In-Reply-To: <1381042912.2081.146.camel@joe-AO722> (from joe@perches.com on
	Sun Oct  6 02:01:52 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1381087154.1974.172@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2013 02:01:52 AM, Joe Perches wrote:
> On Sat, 2013-10-05 at 23:27 -0700, Greg Kroah-Hartman wrote:
> > On Sat, Oct 05, 2013 at 11:51:48AM -0700, Joe Perches wrote:
> > > On Sat, 2013-10-05 at 11:43 -0700, Josh Triplett wrote:
> > > > Kernel maintainers reject new instances of the GPL boilerplate  
> paragraph
> > > > directing people to write to the FSF for a copy of the GPL,  
> since the
> > > > FSF has moved in the past and may do so again.
> > > []
> > > > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > > []
> > > > +# Check for FSF mailing addresses.
> > > > +		if ($rawline =~ /You should have received a  
> copy/ ||
> > > There are over 9,000 of these in the tree.
> > > > +		    $rawline =~ /write to the Free Software/ ||
> > > Over 7,000
> > > > +		    $rawline =~ /59 Temple Place/ ||
> > > Over 3,500
> > > > +		    $rawline =~ /51 Franklin Street/) {
> > > Over 1,500
> >
> > Then we should remove them all.
> []
> > I don't want to see this get worse over time, Josh, thanks for doing
> > this checkpatch patch.
> 
> What about the warranty disclaimer?
> 
> This program is distributed in the hope that it will be useful,
> but WITHOUT ANY WARRANTY; without even the implied warranty of
> MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> GNU General Public License for more details.

It's a historical artifact with little if any legal meaning, but  
lawyers love ass-covering so they'll never tell you to remove a  
raincoat just beacause you live in a desert?

A) It's still in the top level license file (and if you're using a  
distro that has its own collective boilerplate).

If having it in the program's license file isn't enough, why would  
having it at the top of some files help? (Would having it block copied  
before every single function be enough? How about between every line of  
code? THIS line has no warantee. THIS line has no warantee either.)

B) If you have deep enough pockets to be a target they'll go after you  
with a spurious patent suit, not a spurious liability suit.

C) Does your blog have a liability disclaimer? When you visit a website  
like google.com, does it present you with a liability disclaimer on  
each page? (You can navigate to site terms if you try hard enough, but  
"oh no please don't sue us for this thing you never gave us any money  
for and volunteered to use in the first place" is not the first thing  
that comes to mind.)

D) Please show me the high profile lawsuit that made people start doing  
this. We started signed-off-by after SCO filed suit, where's the suit  
that made people do this? I just pulled my copy of Lawrence Graham's  
"Legal Battles that Shaped the Computer Industry" off the shelf and  
neither "Warantee" nor "Disclaimer" are listed in the index.

As far as I can tell current usage is one of those anklets that keep  
sharks away on dry land. ("But there are no sharks around here." "See,  
it's working!" Complete security blanket.)

ORIGINAL usage seems to have been an attempt at coming up with more  
legal boilerplate to look big in the early 80's back before the Apple  
vs Franklin decision extended copyright to cover binaries in 1983. When  
I got a copy of Zork for my commodore 64 in 1982 of course Infocom had  
a card in the box full of big words, saber rattling with meaningless  
legal boilerplate to scare people into "don't copy that floppy" when it  
wasn't actually illegal to do so yet. (This evolved into the  
"shrinkwrap license" nonsense a few years later; by breaking the  
shrinkwrap you agree to the license in the box which you can't read  
without breaking the shrinkwrap, oh yeah THAT instance of "informed  
consent" will hold up in court. Yet software manufacturers did it  
widely for many years before the DMCA made it even sort of greyish.  
Impressive looking legal documents that would never hold up in court  
are as old as the hills...)

No lawyer will ever tell you _not_ to gratuitously cover your ass,  
especially if everybody _else_ is carrying crosses to ward off vampires  
and fully prepared for the coming zombie apocalypse. But where is an  
example of this ever having been a real threat on the level of spurious  
patent suits?

Where are the lawsuits against qmail, whose author famously refused to  
license his code at all for over a decade, and when he did get explicit  
about it he didn't bother with a warantee disclaimer:

   http://cr.yp.to/qmail/dist.html

Or how about libtomcrypt (at the heart of things like the dropbear ssh  
implementation) which has a dual license:

   https://github.com/libtom/libtomcrypt/blob/master/LICENSE

There are hundreds of such packages out there, and we happily use 'em.  
Anyone come up with a warantee lawsuit against someone without a  
disclaimer? Anyone? Bueller? Bueller?

(tl;dr I strongly suspect _one_ Linus Blanket is enough for the tree.  
The one in COPYING.)

Rob

(I'd love to be corrected on this, I've been looking for years. Nobody  
knows, they just keep doing it "just in case". Things like  
http://www.contractstandards.com/contract-structure/representations-and-warranties/software-warranty  
say "Under common law an implied warranty is applied to the sale of  
real property and goods." but there's no _sale_ of a free download, and  
even that goes on in the next paragraph to say nobody ever does this in  
software, I.E. it's NOT common there. And don't get me started on the  
places that can't distinguish between a contract and a license...)

(Oh, did I mention that the lawyers at the Software Freedom Law Center  
were of the opinion that changing the legal boilerplate at the top of  
the files AT ALL, even to correct inaccurate information, was a  
violation of GPLv2? See "the last straw" in  
https://lwn.net/Articles/202120/ except, like patents, it's apparently  
ok to do if you don't know about it so don't read it! Sigh...)