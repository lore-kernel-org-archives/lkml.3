Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751111Ab3JQEEB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 00:04:01 -0400
Received: from smtprelay0122.hostedemail.com ([216.40.44.122]:36488 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750746Ab3JQEEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 00:04:00 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:2:41:355:379:541:599:800:960:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1461:1515:1516:1518:1535:1593:1594:1605:1730:1747:1777:1792:2110:2198:2199:2393:2553:2559:2562:2689:2828:2892:2912:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4049:4118:4250:4321:4605:5007:6119:6691:7652:7903:8531:9010:9121:10004:10848:11232:11233:11658:11914:12043:12295:12296:12324:12346:12517:12519:12679:12681:12740:13019:13138:13141:13161:13172:13180:13184:13229:13230:13231:13869,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: shoes79_5cd4008e3f513
X-Filterd-Recvd-Size: 7390
Message-ID: <1381982635.22110.84.camel@joe-AO722>
Subject: Re: [bug] get_maintainer.pl incomplete output
From: Joe Perches <joe@perches.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Wed, 16 Oct 2013 21:03:55 -0700
In-Reply-To: <alpine.DEB.2.02.1310162046090.30995@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1310161738410.10147@chino.kir.corp.google.com>
	 <alpine.DEB.2.02.1310162046090.30995@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-16 at 20:51 -0700, David Rientjes wrote:
> Hi Joe,

Hi David.

> I haven't looked closely at scripts/get_maintainer.pl, but I recently 
> wrote a patch touching mm/vmpressure.c and it doesn't list the file's 
> author, Anton Vorontsov <anton.vorontsov@linaro.org>.
> 
> Even when I do scripts/get_maintainer.pl -f mm/vmpressure.c, his entry is 
> missing and git blame attributs >90% of the lines to his authorship.
> 
> $ ./scripts/get_maintainer.pl -f mm/vmpressure.c 
> Tejun Heo <tj@kernel.org> (commit_signer:6/7=86%)
> Michal Hocko <mhocko@suse.cz> (commit_signer:5/7=71%)
> Andrew Morton <akpm@linux-foundation.org> (commit_signer:4/7=57%)
> Li Zefan <lizefan@huawei.com> (commit_signer:3/7=43%)
> "Kirill A. Shutemov" <kirill@shutemov.name> (commit_signer:1/7=14%)
> linux-mm@kvack.org (open list:MEMORY MANAGEMENT)
> linux-kernel@vger.kernel.org (open list)
> 
> Any ideas?

get_maintainer has a lot of options.

get_maintainer tries to find people that are either
listed in the MAINTAINERS file or that have recently
(in the last year by default) worked on the file.

If you want to find all authors, use the --git-blame option

It's not the default because it can take quite awhile to run.

If you always want --git-blame added, use a .get_maintainer.conf
file to override the default options.

$ time ./scripts/get_maintainer.pl -f --git-blame mm/vmpressure.c
Tejun Heo <tj@kernel.org> (commit_signer:6/7=86%,commits:5/6=83%)
Michal Hocko <mhocko@suse.cz> (commit_signer:5/7=71%,authored lines:22/387=6%,commits:5/6=83%)
Andrew Morton <akpm@linux-foundation.org> (commit_signer:4/7=57%,commits:4/6=67%)
Li Zefan <lizefan@huawei.com> (commit_signer:3/7=43%,commits:2/6=33%)
"Kirill A. Shutemov" <kirill@shutemov.name> (commit_signer:1/7=14%,commits:1/6=17%)
Anton Vorontsov <anton.vorontsov@linaro.org> (authored lines:354/387=91%)
linux-mm@kvack.org (open list:MEMORY MANAGEMENT)
linux-kernel@vger.kernel.org (open list)

real	0m28.529s
user	0m25.400s
sys	0m0.764s

The --help option is moderately descriptive.
If you think it needs to be better, please say how.

cheers, Joe

$ ./scripts/get_maintainer.pl --help
usage: ./scripts/get_maintainer.pl [options] patchfile
       ./scripts/get_maintainer.pl [options] -f file|directory
version: 0.26

MAINTAINER field selection options:
  --email => print email address(es) if any
    --git => include recent git *-by: signers
    --git-all-signature-types => include signers regardless of signature type
        or use only (Signed-off-by:|Reviewed-by:|Acked-by:) signers (default: 0)
    --git-fallback => use git when no exact MAINTAINERS pattern (default: 1)
    --git-chief-penguins => include (Linus Torvalds)
    --git-min-signatures => number of signatures required (default: 1)
    --git-max-maintainers => maximum maintainers to add (default: 5)
    --git-min-percent => minimum percentage of commits required (default: 5)
    --git-blame => use git blame to find modified commits for patch or file
    --git-since => git history to use (default: 1-year-ago)
    --hg-since => hg history to use (default: -365)
    --interactive => display a menu (mostly useful if used with the --git option)
    --m => include maintainer(s) if any
    --n => include name 'Full Name <addr@domain.tld>'
    --l => include list(s) if any
    --s => include subscriber only list(s) if any
    --remove-duplicates => minimize duplicate email names/addresses
    --roles => show roles (status:subsystem, git-signer, list, etc...)
    --rolestats => show roles and statistics (commits/total_commits, %)
    --file-emails => add email addresses found in -f file (default: 0 (off))
  --scm => print SCM tree(s) if any
  --status => print status if any
  --subsystem => print subsystem name if any
  --web => print website(s) if any

Output type options:
  --separator [, ] => separator for multiple entries on 1 line
    using --separator also sets --nomultiline if --separator is not [, ]
  --multiline => print 1 entry per line

Other options:
  --pattern-depth => Number of pattern directory traversals (default: 0 (all))
  --keywords => scan patch for keywords (default: 1)
  --sections => print all of the subsystem sections with pattern matches
  --mailmap => use .mailmap file (default: 1)
  --version => show version
  --help => show this help information

Default options:
  [--email --nogit --git-fallback --m --n --l --multiline -pattern-depth=0
   --remove-duplicates --rolestats]

Notes:
  Using "-f directory" may give unexpected results:
      Used with "--git", git signators for _all_ files in and below
          directory are examined as git recurses directories.
          Any specified X: (exclude) pattern matches are _not_ ignored.
      Used with "--nogit", directory is used as a pattern match,
          no individual file within the directory or subdirectory
          is matched.
      Used with "--git-blame", does not iterate all files in directory
  Using "--git-blame" is slow and may add old committers and authors
      that are no longer active maintainers to the output.
  Using "--roles" or "--rolestats" with git send-email --cc-cmd or any
      other automated tools that expect only ["name"] <email address>
      may not work because of additional output after <email address>.
  Using "--rolestats" and "--git-blame" shows the #/total=% commits,
      not the percentage of the entire file authored.  # of commits is
      not a good measure of amount of code authored.  1 major commit may
      contain a thousand lines, 5 trivial commits may modify a single line.
  If git is not installed, but mercurial (hg) is installed and an .hg
      repository exists, the following options apply to mercurial:
          --git,
          --git-min-signatures, --git-max-maintainers, --git-min-percent, and
          --git-blame
      Use --hg-since not --git-since to control date selection
  File ".get_maintainer.conf", if it exists in the linux kernel source root
      directory, can change whatever get_maintainer defaults are desired.
      Entries in this file can be any command line argument.
      This file is prepended to any additional command line arguments.
      Multiple lines and # comments are allowed.



