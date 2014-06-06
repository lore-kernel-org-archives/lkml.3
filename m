Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaFFPIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 11:08:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:10341 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaFFPII convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 11:08:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,989,1392192000"; 
   d="scan'208";a="524033217"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: Joe Perches <joe@perches.com>
CC: "apw@canonical.com" <apw@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        postmaster <postmaster@vger.kernel.org>
Subject: RE: [PATCH] checkpatch: warn when patch exceeds a maximum message
 size
Thread-Topic: [PATCH] checkpatch: warn when patch exceeds a maximum message
 size
Thread-Index: AQHPgRqYmzGw4rMJHUaHraTqiFbMAptjwnYAgABqpnA=
Date: Fri, 6 Jun 2014 15:08:05 +0000
Message-ID: <804857E1F29AAC47BF68C404FC60A18465622F2F@ORSMSX105.amr.corp.intel.com>
References: <20140606000037.18356.720.stgit@gitlad.jf.intel.com>
 <1402018556.3038.2.camel@joe-AO725>
In-Reply-To: <1402018556.3038.2.camel@joe-AO725>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Thursday, June 05, 2014 6:36 PM
> To: Allan, Bruce W
> Cc: apw@canonical.com; linux-kernel@vger.kernel.org; postmaster
> Subject: Re: [PATCH] checkpatch: warn when patch exceeds a maximum
> message size
> 
> On Thu, 2014-06-05 at 17:00 -0700, Bruce Allan wrote:
> > the maximum message size (100,000 characters) allowed by Majordomo at
> > vger.kernel.org since that is where most Linux email lists are served.
> 
> I believe this is incorrect and the patch is unnecessary.

Actually, it is correct (it even says so at http://vger.kernel.org/majordomo-info.html).
We just experienced 2 out of 4 patches in the initial RFC submittal of the Intel(R)
QuickAssist Technology (QAT) driver being blocked by Majordomo from getting out
on the linux-crypto mailing list.  It took a while to figure out the problem and had to
break up those two blocked patches into smaller ones which went through fine.  I
submitted this checkpatch patch in hopes to prevent others from having to figure out
the same.

> 
> It'd maybe more interesting if the email header sizes
> were calculated and if > 1024, then some bleating message
> were emitted.
> 
> > Also provide a command-line option to specify a different maximum size.
> >
> > Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
> > ---
> >
> >  scripts/checkpatch.pl |   15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> >
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > index 34eb216..79bd7fd6 100755
> > --- a/scripts/checkpatch.pl
> > +++ b/scripts/checkpatch.pl
> > @@ -40,6 +40,7 @@ my @ignore = ();
> >  my $help = 0;
> >  my $configuration_file = ".checkpatch.conf";
> >  my $max_line_length = 80;
> > +my $max_msg_size = 100000;	# Max allowed by Majordomo at
> vger.kernel.org
> >  my $ignore_perl_version = 0;
> >  my $minimum_perl_version = 5.10.0;
> >
> > @@ -62,6 +63,7 @@ Options:
> >    --types TYPE(,TYPE2...)    show only these comma separated message
> types
> >    --ignore TYPE(,TYPE2...)   ignore various comma separated message
> types
> >    --max-line-length=n        set the maximum line length, if exceeded, warn
> > +  --max-msg-size=n           set the maximum message size, if exceeded,
> warn
> >    --show-types               show the message "types" in the output
> >    --root=PATH                PATH to the kernel tree root
> >    --no-summary               suppress the per-file summary
> > @@ -130,6 +132,7 @@ GetOptions(
> >  	'types=s'	=> \@use,
> >  	'show-types!'	=> \$show_types,
> >  	'max-line-length=i' => \$max_line_length,
> > +	'max-msg-size=i' => \$max_msg_size,
> >  	'root=s'	=> \$root,
> >  	'summary!'	=> \$summary,
> >  	'mailback!'	=> \$mailback,
> > @@ -4600,6 +4603,18 @@ sub process {
> >  		exit(0);
> >  	}
> >
> > +	# Warn if patch exceeds the maximum message size
> > +	if (!$file) {
> > +		my $cnt_chars = 0;
> > +		foreach my $rawline (@rawlines) {
> > +			$cnt_chars += length($rawline) + 1;
> > +		}
> > +		if ($cnt_chars > $max_msg_size) {
> > +			WARN("PATCH_TOO_LARGE",
> > +			     "patch exceeds maximum message size
> ($max_msg_size) and might be blocked by email list server(s).\n");
> > +		}
> > +	}
> > +
> >  	if (!$is_patch) {
> >  		ERROR("NOT_UNIFIED_DIFF",
> >  		      "Does not appear to be a unified-diff format patch\n");
> >
> 
> 

