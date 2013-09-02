Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947Ab3IBTyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 15:54:55 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:48512 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757112Ab3IBTyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 15:54:54 -0400
X-AuditID: cbfec372-b7fe76d000003347-b0-5224ed0c9a64
Date: Mon, 02 Sep 2013 16:54:46 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Joe Perches <joe@perches.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [Ksummit-2013-discuss] [PATCH] checkpatch: Add warning about
 submitting patches using --file
Message-id: <20130902165446.7db11c2e@samsung.com>
In-reply-to: <1378150847.1953.106.camel@joe-AO722>
References: <9976.1378132260@warthog.procyon.org.uk>
 <1378138205.1953.66.camel@joe-AO722> <20130902181510.GA29787@leaf>
 <20130902181856.GB29787@leaf> <1378150847.1953.106.camel@joe-AO722>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t/hQF2etypBBh+mWlvMWb+GzeLDWg2L
	1/+ms1jMvv+YxeL/gnyLWz/mMllc3jWHzeJR31t2Bw6PWQ29bB63Xtt6nJjxm8Xj94/JjB4f
	n95i8fiy6hqzx+dNcgHsUVw2Kak5mWWpRfp2CVwZx/q2sxTs5q1Yv6aXqYHxBVcXIyeHhICJ
	xIwHO9ggbDGJC/fWA9lcHEICSxglNq3YwQzhdDNJ3HrTygxSxSKgKnGqcSITiM0mYCTxqrGF
	tYuRg0NEQFHi7hZ+kHpmgVVMEhO394HVCAtkSzxd0w/WyytgKNH+t48NpJ4TqLdlRg3E/P2M
	Em03L7ODxCUEnCS2TvWFKBeU+DH5HguIzSygJbF5WxMrhC0vsXnNW+YJjAKzkJTNQlI2C0nZ
	AkbmVYyipcXJBcVJ6bmGesWJucWleel6yfm5mxghwV+0g/HZBqtDjAIcjEo8vBx7VYKEWBPL
	iitzDzFKcDArifD+ngwU4k1JrKxKLcqPLyrNSS0+xMjEwSnVwMi55VTqT6/UdW7ODzfIJz/k
	PPtM5uX5suIn+yocj8RUCDmmyH3yu7O10jVsxsFb3uy+4Q3Fz7ekXU3rzk2JvdjQvy+qdnVV
	nJl+xIWLBdPezMxztvb0aq00MX2v37B/wZRVvVuW3PgesyvZfPmOqQzuPzpVnNh4WX8zr/VS
	7LWIufVq1f/PlUosxRmJhlrMRcWJAKF7b8ZcAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 02 Sep 2013 12:40:47 -0700
Joe Perches <joe@perches.com> escreveu:

> Add a message describing the lack of value in using
> --file to generate patches.
> 
> Exclude files in staging from this message.
> 
> A similar message was removed by commit cf655043d4b
> ("update checkpatch.pl to version 0.15")
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

> ---
> 
> Maybe this sort of wordsmithing is valuable.
> 
>  scripts/checkpatch.pl | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 9bb056c..f788a14 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -4280,6 +4280,19 @@ $vname has style problems, please review.
>  If any of these errors are false positives, please report
>  them to the maintainer, see CHECKPATCH in MAINTAINERS.
>  EOM
> +		if ($file && $realfile !~ m@\bstaging/@) {
> +			print << "EOM";
> +
> +WARNING: When using --file mode, do not send patches that just make
> +whitespace or formatting changes unless more significant changes are
> +also made for other reasons in another patch.
> +
> +Patches that are just code style changes have a real cost.
> +
> +These sort of patches can cause rejects with other changes and are
> +thought of by many maintainers as more harmful and tiresome than useful.
> +EOM
> +		}
>  	}
>  
>  	return $clean;
> 
> 
> _______________________________________________
> Ksummit-2013-discuss mailing list
> Ksummit-2013-discuss@lists.linuxfoundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/ksummit-2013-discuss


-- 

Cheers,
Mauro
