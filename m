Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab3J1JJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 05:09:57 -0400
Received: from alum-mailsec-scanner-7.mit.edu ([18.7.68.19]:48214 "EHLO
	alum-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755849Ab3J1JJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 05:09:54 -0400
X-Greylist: delayed 421 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Oct 2013 05:09:54 EDT
X-AuditID: 12074413-b7fc76d000002aba-ed-526e283c3d0f
Message-ID: <526E283A.1070801@alum.mit.edu>
Date: Mon, 28 Oct 2013 10:02:50 +0100
From: Michael Haggerty <mhagger@alum.mit.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: git@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Greg KH <greg@kroah.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        ksummit-attendees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] commit: Add -f, --fixes <commit> option to add Fixes:
 line
References: <20131024122255.GI9378@mwanda> <20131024122512.GB9534@mwanda> <20131026181709.GB10488@kroah.com> <20131027013402.GA7146@leaf> <526CA7D4.1070904@alum.mit.edu> <20131027071407.GA11683@leaf>
In-Reply-To: <20131027071407.GA11683@leaf>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJKsWRmVeSWpSXmKPExsUixO6iqGujkRdksHKZgcXrf9NZLLqudDNZ
	nFswg9Hi/4J8i1s/5jJZvHp0icni8q45bA7sHrde23q8fRjg8fvHZEaPj09vsXh83iQXwBrF
	bZOUWFIWnJmep2+XwJ1xfvMCtoINmhWnZik0MK5U7GLk5JAQMJG4tfUQI4QtJnHh3nq2LkYu
	DiGBy4wSj1d8ZIFwzjJJPLvzgQmkildAW+LrlkZ2EJtFQFXi7fw3YDabgK7Eop5msBpRgRCJ
	hauOs0PUC0qcnPkEaBAHh4iApsT0zUogM5kFfjFKbD/6A6xGWCBQovfKPKhlxxkldq1cCDaI
	U0BL4ui5H2wgNrOAjsS7vgfMELa8xPa3c5gnMArMQrJjFpKyWUjKFjAyr2KUS8wpzdXNTczM
	KU5N1i1OTszLSy3SNdfLzSzRS00p3cQICXrhHYy7TsodYhTgYFTi4Y1YnRskxJpYVlyZe4hR
	koNJSZQ3VjUvSIgvKT+lMiOxOCO+qDQntfgQowQHs5IIrwlIjjclsbIqtSgfJiXNwaIkzqu2
	RN1PSCA9sSQ1OzW1ILUIJivDwaEkwSupDtQoWJSanlqRlplTgpBm4uAEGc4lJVKcmpeSWpRY
	WpIRD4rV+GJgtIKkeID2SoO08xYXJOYCRSFaTzHqcsz78uEboxBLXn5eqpQ4rxxIkQBIUUZp
	HtwKWIp7xSgO9LEwryZIFQ8wPcJNegW0hAloyR4WsCUliQgpqQZG3YuTFqTPtPU40dXvLCvx
	4GvPtTm73UrWuPpeNupaGhQ1Izz97NmsxoSHOc3LVvPvWrfRPqleQaokuursfs7pqgqTswO6
	bs7wcq95u0iIc9+PO9p/tvVqZlwNDe0Nuj/16Lx1wTE/T3307v/30uyuw+/QE6eN2HuPbmqo
	c45nTLsq7he5jK1TiaU4I9FQi7moOBEAR5nx3UwDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2013 08:14 AM, Josh Triplett wrote:
> On Sun, Oct 27, 2013 at 06:42:44AM +0100, Michael Haggerty wrote:
>> On 10/27/2013 02:34 AM, Josh Triplett wrote:
>> [...]
>> First of all, let me show my ignorance.  How formalized is the use of
>> metadata lines at the end of a commit message?  I don't remember seeing
>> documentation about such lines in general (as opposed to documentation
>> about particular types of lines).  Is the format defined well enough
>> that tools that don't know about a particular line could nonetheless
>> preserve it correctly?  Is there/should there be a standard recommended
>> order of metadata lines?  (For example, should "Fixes:" lines always
>> appear before "Signed-off-by" lines, or vice versa?)  If so, is it
>> documented somewhere and preserved by tools when such lines are
>> added/modified?  Should there be support for querying such lines?
> 
> While it isn't very well documented in git itself, metadata lines are
> quite standardized.  See Documentation/SubmittingPatches and
> Documentation/development-process/5.Posting in the Linux kernel, for an
> explanation of "Reported-by:", "Tested-by:", "Reviewed-by:",
> "Suggested-by:", and "Acked-by:".  And git itself looks for a very
> specific format; the has_conforming_footer function looks for a footer
> consisting exclusively of rfc2822-style (email-style) header lines to
> decide whether to append "Signed-off-by:" (and now "Fixes:") directly to
> that block or to create a new block.

It would be nice to document exactly what "rfc2822-style" means in this
context (e.g., are line breaks supported?  Encoding changes?  etc.) so
that (1) new inventors of trailer lines can make sure that they conform
to what Git expects and (2) Git could someday add some generic
facilities for handling these fields (e.g., adding/removing/tidying them
in a commit-msg hook; grepping through them by name) and be relatively
sure that it is not breaking somebody's metadata.

I'm not saying that it's your job; only that it would be helpful for
ideas like yours.

> [...]
>> I wonder if the two features could
>> be combined in some way?
>>
>> The main difference between the two features is how they are intended to
>> be used: --fixup is to fix a commit that hasn't been pushed yet (where
>> the user intends to squash the commits together), whereas --fixes is to
>> mark a commit as a fix to a commit that has already been pushed (where
>> the commits will remain separate).  But there seems to be a common
>> concept here.
>>
>> For example, what happens if a --fixes commit is "rebase -i"ed at the
>> same time as the commit that it fixes?  It might make sense to do the
>> autosquash thing just like with a --fixup/--squash commit.  (Otherwise
>> the SHA-1 in the "Fixes:" line will become invalid anyway.)
> 
> Most definitely not, no, at least not without an explicit option to
> enable that.  Consider the case of backporting a series of patches and
> preserving the relative history of those patches, to make it easier to
> match up a set of patches.  At most, it might be a good idea for
> cherry-pick or similar to provide an updated Fixes tag for the new hash
> of the older commit.  Personally, I'd argue against doing this even with
> --autosquash.  I could see the argument for an --autosquash-fixes, but I
> can't think of a real-world scenario where what would come up.
> 
> Generally, if history is still editable, you should just squash in the
> fix to the original commit, and if history is no longer editable (which
> is the use case for "Fixes:" lines), the squash case simply won't come
> up, offering little point to adding special support for that case.

In your last paragraph you explain exactly why these two features are
similar and why it is thinkable to make the way that they are handled
depend on the context.  Exactly because one would never rebase a
"Fixes:" commit and the commit it is fixing at the same time, they would
never be squashed together.  And ISTM that in most cases whenever they
*are* being rebased at the same time, then one would want to squash them
together.  So it might be possible to mark both types of commits the
same way and then squash/not squash them depending on the context and
the --autosquash option.

> [...]
>> I see that there a consistency check that the --fixes argument is a
>> valid commit.  But is there/should there be a check that it is an
>> ancestor of the commit being created?  Is there/should there be a check
>> that both of these facts remain true if the the commit containing it is
>> rebased, cherry-picked, etc?
> 
> That sounds like a nice future enhancement, sure.  I don't have any plans to
> add such a check myself, though.  Also note that --fixup and --squash
> don't have such a check either; if you want to add one, you should add
> it for all three options at once.

A hook-based solution could do this.  But a built-in "all-purpose"
handler like "footer.Fixes.arg=commit", which was intended to be
reusable, wouldn't be able to do such footer-specific extra work without
having to create new special cases in git each time.

Michael

-- 
Michael Haggerty
mhagger@alum.mit.edu
http://softwareswirl.blogspot.com/
