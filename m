Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbaFBTF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 15:05:27 -0400
Received: from smtprelay0021.hostedemail.com ([216.40.44.21]:43788 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751998AbaFBTFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 15:05:24 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3
X-HE-Tag: cloth39_85beec49f4926
X-Filterd-Recvd-Size: 3824
Message-ID: <1401735917.7323.23.camel@joe-AO725>
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
From: Joe Perches <joe@perches.com>
To: josh@joshtriplett.org
Cc: Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        sbw@mit.edu
Date: Mon, 02 Jun 2014 12:05:17 -0700
In-Reply-To: <20140602185504.GA13569@cloud>
References: <1401728420-3572-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1401729778.5770.20.camel@joe-AO725> <20140602174837.GA13257@cloud>
	 <1401731968.7323.4.camel@joe-AO725>
	 <20140602181658.GX22231@linux.vnet.ibm.com>
	 <1401734669.7323.20.camel@joe-AO725>
	 <20140602145020.400d4e0c@gandalf.local.home> <20140602185504.GA13569@cloud>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-02 at 11:55 -0700, josh@joshtriplett.org wrote:
> this should go along with a change to
> get_maintainer.pl to add those folks to the CC list.

Something like this:
---
 scripts/get_maintainer.pl | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 4198788..d701627 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -21,6 +21,7 @@ my $lk_path = "./";
 my $email = 1;
 my $email_usename = 1;
 my $email_maintainer = 1;
+my $email_reviewer = 1;
 my $email_list = 1;
 my $email_subscriber_list = 0;
 my $email_git_penguin_chiefs = 0;
@@ -202,6 +203,7 @@ if (!GetOptions(
 		'remove-duplicates!' => \$email_remove_duplicates,
 		'mailmap!' => \$email_use_mailmap,
 		'm!' => \$email_maintainer,
+		'r!' => \$email_reviewer,
 		'n!' => \$email_usename,
 		'l!' => \$email_list,
 		's!' => \$email_subscriber_list,
@@ -260,7 +262,8 @@ if ($sections) {
 }
 
 if ($email &&
-    ($email_maintainer + $email_list + $email_subscriber_list +
+    ($email_maintainer + $email_reviewer +
+     $email_list + $email_subscriber_list +
      $email_git + $email_git_penguin_chiefs + $email_git_blame) == 0) {
     die "$P: Please select at least 1 email option\n";
 }
@@ -750,6 +753,7 @@ MAINTAINER field selection options:
     --hg-since => hg history to use (default: $email_hg_since)
     --interactive => display a menu (mostly useful if used with the --git option)
     --m => include maintainer(s) if any
+    --r => include reviewer(s) if any
     --n => include name 'Full Name <addr\@domain.tld>'
     --l => include list(s) if any
     --s => include subscriber only list(s) if any
@@ -1064,6 +1068,22 @@ sub add_categories {
 		    my $role = get_maintainer_role($i);
 		    push_email_addresses($pvalue, $role);
 		}
+	    } elsif ($ptype eq "R") {
+		my ($name, $address) = parse_email($pvalue);
+		if ($name eq "") {
+		    if ($i > 0) {
+			my $tv = $typevalue[$i - 1];
+			if ($tv =~ m/^(\C):\s*(.*)/) {
+			    if ($1 eq "P") {
+				$name = $2;
+				$pvalue = format_email($name, $address, $email_usename);
+			    }
+			}
+		    }
+		}
+		if ($email_reviewer) {
+		    push_email_addresses($pvalue, 'reviewer');
+		}
 	    } elsif ($ptype eq "T") {
 		push(@scm, $pvalue);
 	    } elsif ($ptype eq "W") {



