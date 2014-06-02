Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbaFBTJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 15:09:59 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:45683 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbaFBTJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 15:09:57 -0400
Date: Mon, 2 Jun 2014 12:09:51 -0700
From: josh@joshtriplett.org
To: Joe Perches <joe@perches.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
Message-ID: <20140602190951.GA13648@cloud>
References: <1401728420-3572-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1401729778.5770.20.camel@joe-AO725>
 <20140602174837.GA13257@cloud>
 <1401731968.7323.4.camel@joe-AO725>
 <20140602181658.GX22231@linux.vnet.ibm.com>
 <1401734669.7323.20.camel@joe-AO725>
 <20140602145020.400d4e0c@gandalf.local.home>
 <20140602185504.GA13569@cloud>
 <1401735917.7323.23.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401735917.7323.23.camel@joe-AO725>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 12:05:17PM -0700, Joe Perches wrote:
> On Mon, 2014-06-02 at 11:55 -0700, josh@joshtriplett.org wrote:
> > this should go along with a change to
> > get_maintainer.pl to add those folks to the CC list.
> 
> Something like this:

Yes, exactly.  Given an appropriate commit message,
Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> ---
>  scripts/get_maintainer.pl | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
> index 4198788..d701627 100755
> --- a/scripts/get_maintainer.pl
> +++ b/scripts/get_maintainer.pl
> @@ -21,6 +21,7 @@ my $lk_path = "./";
>  my $email = 1;
>  my $email_usename = 1;
>  my $email_maintainer = 1;
> +my $email_reviewer = 1;
>  my $email_list = 1;
>  my $email_subscriber_list = 0;
>  my $email_git_penguin_chiefs = 0;
> @@ -202,6 +203,7 @@ if (!GetOptions(
>  		'remove-duplicates!' => \$email_remove_duplicates,
>  		'mailmap!' => \$email_use_mailmap,
>  		'm!' => \$email_maintainer,
> +		'r!' => \$email_reviewer,
>  		'n!' => \$email_usename,
>  		'l!' => \$email_list,
>  		's!' => \$email_subscriber_list,
> @@ -260,7 +262,8 @@ if ($sections) {
>  }
>  
>  if ($email &&
> -    ($email_maintainer + $email_list + $email_subscriber_list +
> +    ($email_maintainer + $email_reviewer +
> +     $email_list + $email_subscriber_list +
>       $email_git + $email_git_penguin_chiefs + $email_git_blame) == 0) {
>      die "$P: Please select at least 1 email option\n";
>  }
> @@ -750,6 +753,7 @@ MAINTAINER field selection options:
>      --hg-since => hg history to use (default: $email_hg_since)
>      --interactive => display a menu (mostly useful if used with the --git option)
>      --m => include maintainer(s) if any
> +    --r => include reviewer(s) if any
>      --n => include name 'Full Name <addr\@domain.tld>'
>      --l => include list(s) if any
>      --s => include subscriber only list(s) if any
> @@ -1064,6 +1068,22 @@ sub add_categories {
>  		    my $role = get_maintainer_role($i);
>  		    push_email_addresses($pvalue, $role);
>  		}
> +	    } elsif ($ptype eq "R") {
> +		my ($name, $address) = parse_email($pvalue);
> +		if ($name eq "") {
> +		    if ($i > 0) {
> +			my $tv = $typevalue[$i - 1];
> +			if ($tv =~ m/^(\C):\s*(.*)/) {
> +			    if ($1 eq "P") {
> +				$name = $2;
> +				$pvalue = format_email($name, $address, $email_usename);
> +			    }
> +			}
> +		    }
> +		}
> +		if ($email_reviewer) {
> +		    push_email_addresses($pvalue, 'reviewer');
> +		}
>  	    } elsif ($ptype eq "T") {
>  		push(@scm, $pvalue);
>  	    } elsif ($ptype eq "W") {
> 
> 
> 
