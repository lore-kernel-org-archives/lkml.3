Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab3JFXQ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 19:16:59 -0400
Received: from smtprelay0235.hostedemail.com ([216.40.44.235]:53488 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754831Ab3JFXQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 19:16:58 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:966:973:982:988:989:1042:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3653:3698:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:4385:5007:6119:6120:7652:7901:10004:10226:10400:10848:11026:11232:11473:11658:11914:12043:12517:12519:12555:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fact33_3c9388066b151
X-Filterd-Recvd-Size: 2991
Message-ID: <1381101414.2081.172.camel@joe-AO722>
Subject: Re: [PATCHv2] checkpatch.pl: Check for the FSF mailing address
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Date: Sun, 06 Oct 2013 16:16:54 -0700
In-Reply-To: <20131006222342.GT19510@leaf>
References: <20131005184307.GA6429@leaf>
	 <1380999108.2081.138.camel@joe-AO722> <20131006062739.GA5218@kroah.com>
	 <20131006211855.GB19510@leaf> <1381094837.2081.160.camel@joe-AO722>
	 <20131006213309.GO19510@leaf> <1381096127.2081.166.camel@joe-AO722>
	 <20131006222342.GT19510@leaf>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding Andrew Morton)

On Sun, 2013-10-06 at 15:23 -0700, Josh Triplett wrote:
> Kernel maintainers reject new instances of the GPL boilerplate paragraph
> directing people to write to the FSF for a copy of the GPL, since the
> FSF has moved in the past and may do so again.
> 
> Make this an error for new code, but just a --strict CHK in --file mode;
> anyone interested in doing tree-wide cleanups of this form can enable
> this test explicitly.
> 
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> ---
> 
> v2: Make this a CHK in --file mode, using a code pattern suggested by
>     Joe Perches.
> 
>  scripts/checkpatch.pl | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 2ee9eb7..9161533 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1859,6 +1859,18 @@ sub process {
>  			$rpt_cleaners = 1;
>  		}
>  
> +# Check for FSF mailing addresses.
> +		if ($rawline =~ /You should have received a copy/ ||
> +		    $rawline =~ /write to the Free Software/ ||
> +		    $rawline =~ /59 Temple Place/ ||
> +		    $rawline =~ /51 Franklin Street/) {
> +			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
> +			my $msg_type = \&ERROR;
> +			$msg_type = \&CHK if ($file);
> +			&{$msg_type}("FSF_MAILING_ADDRESS",
> +				"Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so again. Linux already includes a copy of the GPL.\n" . $herevet)
> +		}
> +
>  # check for Kconfig help text having a real description
>  # Only applies when adding the entry originally, after that we do not have
>  # sufficient context to determine whether it is indeed long enough.

Acked-by: Joe Perches <joe@perches.com>


