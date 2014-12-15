Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832AbaLOQeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 11:34:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:40210 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaLOQd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 11:33:59 -0500
Message-ID: <548F0D71.8090007@infradead.org>
Date: Mon, 15 Dec 2014 08:33:53 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>, LKML <linux-kernel@vger.kernel.org>
CC: Corey Minyard <cminyard@mvista.com>
Subject: Re: [PATCH RFC] Docs: Modernize SubmittingPatches
References: <20141215105251.16913f8c@lwn.net>
In-Reply-To: <20141215105251.16913f8c@lwn.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

Overall this is good but it was difficult to review -- maybe too many
varying types of changes.

I have a few minor corrections below. Use them (or not) any way that you like.


On 12/15/14 07:52, Jonathan Corbet wrote:
> The SubmittingPatches file still shows a lot of its roots from the era when
> we all sent stuff straight to Linus and hoped for the best.  I've gone in
> and thrashed it up to reflect an age where few of us type our own "diff"
> commands anymore.  Also added a section on preparing signed tags for pull
> requests.
> 
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
> ---
>  Documentation/SubmittingPatches | 433 ++++++++++++++++++++--------------------
>  1 file changed, 212 insertions(+), 221 deletions(-)
> 
> diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
> index 1fa1caa198eb..787d0711e18a 100644
> --- a/Documentation/SubmittingPatches
> +++ b/Documentation/SubmittingPatches

[snip]

> -5) Select e-mail destination.
> +You should be able to justify all violations that remain in your
> +patch.
>  
> -Look through the MAINTAINERS file and the source code, and determine
> -if your change applies to a specific subsystem of the kernel, with
> -an assigned maintainer.  If so, e-mail that person.  The script
> -scripts/get_maintainer.pl can be very useful at this step.
>  
> -If no maintainer is listed, or the maintainer does not respond, send
> -your patch to the primary Linux kernel developer's mailing list,
> -linux-kernel@vger.kernel.org.  Most kernel developers monitor this
> -e-mail list, and can comment on your changes.
> +5) Select the recipients for your patch.
> +----------------------------------------
>  
> +You should always copy the appropriate subsystem maintainer(s) on any patch
> +to code that they maintain; Look through the MAINTAINERS file and the

                     maintain.
alternately:                 ; look

> +source code revision history to see who those maintainers are.  The
> +script scripts/get_maintainer.pl can be very useful at this step.  If you
> +cannot find a maintainer for the subsystem your are working on, Andrew
> +Morton (akpm@linux-foundation.org) serves as a maintainer of last resort.

[snip]

> +Patches that fix a severe bug in a released kernel should be directed
> +toward the stable maintainers; putting a line like this:

                     maintainers by putting a line like this in your patch:

>  
> +  Cc: stable@vger.kernel.org
>  
> -6) Select your CC (e-mail carbon copy) list.
> +Note, however, that some subsystem maintainers want to come to their own
> +conclusions on which patches should go to the stable trees.  The networking
> +maintainer, in particular, would rather not see individual developers
> +adding lines like the above to their patches.

[snip]

> +7) E-mail size.
> +---------------
>  
>  Large changes are not appropriate for mailing lists, and some
>  maintainers.  If your patch, uncompressed, exceeds 300 kB in size,
>  it is preferred that you store your patch on an Internet-accessible
> -server, and provide instead a URL (link) pointing to your patch.
> +server, and provide instead a URL (link) pointing to your patch.  But note
> +that if your patch exceeds 300kB, it almost certainly needs to be broken up

                              300 kB  [as above, or change the other one]

> +anyway.
>  
> +8) Respond to review comments.
> +------------------------------
>  
> +Your patch will almost certainly get comments from reviewers on ways in
> +which the patch can be improved.  You must respond to those comments;
> +ignoring reviewers is a good way to get ignored in return.  Review comments
> +or questions that to not lead to a code change should almost certainly

                     do not

> +bring about a comment or changelog entry so that the next reviewer better
> +understands what is going on.
>  
> -9) Name your kernel version.
> +Be sure to tell the reviewers what changes you are making and to thank them
> +for their time.  Code review is a tiring and time-consuming process, and
> +reviewers sometimes get grumpy.  Even in that case, though, respond
> +politely and address the problems they have pointed out.
>  
> -It is important to note, either in the subject line or in the patch
> -description, the kernel version to which this patch applies.
>  
> -If the patch does not apply cleanly to the latest kernel version,
> -Linus will not apply it.
> +9) Don't get discouraged - or impatient.
> +----------------------------------------
>  
> +After you have submitted your change, be patient and wait.  Reviewers are
> +busy people and may not get to your patch right away.
>  
> +Once upon a time, patches used to dissappear into the void without comment,

                                     disappear

> +but the development process works more smoothly than that now.  You should
> +receive comments within a week or so; if that does not happen, make sure
> +that you have sent your patches to the right place.  Wait for a minimum of
> +one week before resubmitting or pinging reviewers - possibly longer during
> +busy times like merge windows.

[snip]

> @@ -541,7 +592,13 @@ which stable kernel versions should receive your fix. This is the preferred
>  method for indicating a bug fixed by the patch. See #2 above for more details.
>  
>  
> -15) The canonical patch format
> +14) The canonical patch format
> +------------------------------
> +
> +This section describes how the patch itself should be formatted.  Note
> +that, if you have your patches stored in a git repository, proper patch
> +formatting can be had with "git format-patch".  The tools can not create

                                                             cannot

> +the necessary text, though, so read the instructions below anyway.
>  
>  The canonical patch subject line is:

[snip]



-- 
~Randy
