Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751348AbaL0NTZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 08:19:25 -0500
Received: from sf2.bxl.stone.is ([5.134.1.239]:36749 "EHLO sf2.bxl.stone.is"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbaL0NTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 08:19:22 -0500
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
Message-ID: <549EB1CA.60709@acm.org>
Date: Sat, 27 Dec 2014 14:19:06 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: Johannes Berg <johannes.berg@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] kerneldoc: Convert error messages to GNU error message format
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Filter-ID: s0sct1PQhAABKnZB5plbIYrcAt68paBzxGNV4bZScc8DDDH9IcRzs4ldqK5vEMwbuZt+PpRPW1h0
 yigPev+a+/TNQVt+4bHJxT5PjDNPJb9LgQwS6soZ57t6MQUUOVFT+lrONZiB+2vF4NosGJk/bCbL
 pIjEUi85nfAGaTi8rkn/gbuP7hnUK8NQdLwsVWKI0Zt4DuQQDiEIiIy/fnjQwPT2ZVO/gQPd97hw
 tQBro4wywd9Pq4aYKQBCFFE6LuJoaRH2vlhuc0VRmMGgXAT7lCG7X+t1TW39Ja77LGPpOwBiLuZy
 DqdwXS7XyXKlBMsj0oq6DMJUNvvXVKZBkDDKGUHyFKNhRE3mHd0j29nsWFOuyFYQZcmh2mMcqcZy
 v6wweBY3LaRQnu7GAef7rEBCvzoPwrFx31nY/waF59cyHVmCkhKmRqM75EmAb0BbLzodz2sRZukG
 DdIPf+efSMBiV1SqeZhBqz8nR05j/2nHmzpvZ34Foe+UNQHV9z+TdapqPKzeZD3bmKDo0ZP+EsXA
 Vo40DbV0SkkdbDg9vPd9OLM6YJM2wTJFrRk1JkkXZzTU6qzWdRILWaJ3e6thSgtFdg4wfPg8ZnSc
 jIGj/wSYVzC9PCpRCEQf9c4RK7WT+IxY++DuIQUs/5JJj4C/n4CILj+81cUPPzIp7Ly910lWjPO8
 7Dct74cRxRIcxFFtrOMvJRvornEfMDAlR8h7IpqP24TCGR3UopcBf2VNncCqr+A=
X-Report-Abuse-To: spam@sf1.bxl.stone.is
X-Filter-Fingerprint: IFrWXGses7OKB5S5G8/dJdIz5bb8V0ykx8BnFBnunHBA3cTUQ1R++keuE7RDJ8Kg3RbMLUalw1oC
 mj99/u+PoqoVy8a3lsStJtAvpObFX0Wok1JBYnOLzfRIhlEHQynLUpndEJ0YoaLytXXo8BMTaX2p
 Mk7LBarWD9Fj4R3eIu5cOy/3Wm9qfF/CZNvP/2Kowv61T+KDYyYtREgszdyFwv8IxCB3p/oCKvxr
 eyISh3JGb7OS5oVgiO+kDxZrVPLz3MmEGC2PrUKqLq5WmHK+Nw==
X-Originating-IP: 87.238.167.34
X-SpamExperts-Domain: stone.is
X-SpamExperts-Username: 87.238.167.34
Authentication-Results: bxl.stone.is; auth=pass smtp.auth=87.238.167.34
X-SpamExperts-Outgoing-Class: ham
X-SpamExperts-Outgoing-Evidence: SB/global_tokens (0.00923040717295)
X-Recommended-Action: accept
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Editors like emacs and vi recognize a number of error message
formats. The format used by the kerneldoc tool is not recognized
by emacs. Change the kerneldoc error message format to the GNU
style such that the emacs prev-error and next-error commands can
be used to navigate through kerneldoc error messages. For more
information about the GNU error message format, see also
https://www.gnu.org/prep/standards/html_node/Errors.html.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Johannes Berg <johannes.berg@intel.com>
---
 scripts/kernel-doc | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index 9922e66..286e90d 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -423,7 +423,7 @@ sub dump_section {
     } else {
 #	print STDERR "other section '$name' = '$contents'\n";
 	if (defined($sections{$name}) && ($sections{$name} ne "")) {
-		print STDERR "Error(${file}:$.): duplicate section name '$name'\n";
+		print STDERR "${file}:$.: error: duplicate section name '$name'\n";
 		++$errors;
 	}
 	$sections{$name} = $contents;
@@ -1772,7 +1772,7 @@ sub dump_struct($$) {
 			   });
     }
     else {
-	print STDERR "Error(${file}:$.): Cannot parse struct or union!\n";
+	print STDERR "${file}:$.: error: Cannot parse struct or union!\n";
 	++$errors;
     }
 }
@@ -1793,7 +1793,7 @@ sub dump_enum($$) {
 	    push @parameterlist, $arg;
 	    if (!$parameterdescs{$arg}) {
 		$parameterdescs{$arg} = $undescribed;
-		print STDERR "Warning(${file}:$.): Enum value '$arg' ".
+		print STDERR "${file}:$.: warning: Enum value '$arg' ".
 		    "not described in enum '$declaration_name'\n";
 	    }
 
@@ -1811,7 +1811,7 @@ sub dump_enum($$) {
 			   });
     }
     else {
-	print STDERR "Error(${file}:$.): Cannot parse enum!\n";
+	print STDERR "${file}:$.: error: Cannot parse enum!\n";
 	++$errors;
     }
 }
@@ -1839,7 +1839,7 @@ sub dump_typedef($$) {
 			   });
     }
     else {
-	print STDERR "Error(${file}:$.): Cannot parse typedef!\n";
+	print STDERR "${file}:$.: error: Cannot parse typedef!\n";
 	++$errors;
     }
 }
@@ -1971,11 +1971,11 @@ sub push_parameter($$$) {
 	    $parameterdescs{$param_name} = $undescribed;
 
 	    if (($type eq 'function') || ($type eq 'enum')) {
-		print STDERR "Warning(${file}:$.): Function parameter ".
+		print STDERR "${file}:$.: warning: Function parameter ".
 		    "or member '$param' not " .
 		    "described in '$declaration_name'\n";
 	    }
-	    print STDERR "Warning(${file}:$.):" .
+	    print STDERR "${file}:$.: warning:" .
 			 " No description found for parameter '$param'\n";
 	    ++$warnings;
 	}
@@ -2026,14 +2026,14 @@ sub check_sections($$$$$$) {
 		}
 		if ($err) {
 			if ($decl_type eq "function") {
-				print STDERR "Warning(${file}:$.): " .
+				print STDERR "${file}:$.: warning: " .
 					"Excess function parameter " .
 					"'$sects[$sx]' " .
 					"description in '$decl_name'\n";
 				++$warnings;
 			} else {
 				if ($nested !~ m/\Q$sects[$sx]\E/) {
-				    print STDERR "Warning(${file}:$.): " .
+				    print STDERR "${file}:$.: warning: " .
 					"Excess struct/union/enum/typedef member " .
 					"'$sects[$sx]' " .
 					"description in '$decl_name'\n";
@@ -2059,7 +2059,7 @@ sub check_return_section {
 
         if (!defined($sections{$section_return}) ||
             $sections{$section_return} eq "") {
-                print STDERR "Warning(${file}:$.): " .
+                print STDERR "${file}:$.: warning: " .
                         "No description found for return value of " .
                         "'$declaration_name'\n";
                 ++$warnings;
@@ -2138,7 +2138,7 @@ sub dump_function($$) {
 
 	create_parameterlist($args, ',', $file);
     } else {
-	print STDERR "Warning(${file}:$.): cannot understand function prototype: '$prototype'\n";
+	print STDERR "${file}:$.: warning: cannot understand function prototype: '$prototype'\n";
 	return;
     }
 
@@ -2202,7 +2202,7 @@ sub tracepoint_munge($) {
 		$tracepointargs = $1;
 	}
 	if (($tracepointname eq 0) || ($tracepointargs eq 0)) {
-		print STDERR "Warning(${file}:$.): Unrecognized tracepoint format: \n".
+		print STDERR "${file}:$.: warning: Unrecognized tracepoint format: \n".
 			     "$prototype\n";
 	} else {
 		$prototype = "static inline void trace_$tracepointname($tracepointargs)";
@@ -2401,7 +2401,7 @@ sub process_file($) {
 		}
 
 		if (($declaration_purpose eq "") && $verbose) {
-			print STDERR "Warning(${file}:$.): missing initial short description on line:\n";
+			print STDERR "${file}:$.: warning: missing initial short description on line:\n";
 			print STDERR $_;
 			++$warnings;
 		}
@@ -2419,10 +2419,10 @@ sub process_file($) {
 		}
 
 		if ($verbose) {
-		    print STDERR "Info(${file}:$.): Scanning doc for $identifier\n";
+		    print STDERR "${file}:$.: info: Scanning doc for $identifier\n";
 		}
 	    } else {
-		print STDERR "Warning(${file}:$.): Cannot understand $_ on line $.",
+		print STDERR "${file}:$.: warning: Cannot understand $_ on line $.",
 		" - I thought it was a doc line\n";
 		++$warnings;
 		$state = 0;
@@ -2434,7 +2434,7 @@ sub process_file($) {
 
 		if (($contents ne "") && ($contents ne "\n")) {
 		    if (!$in_doc_sect && $verbose) {
-			print STDERR "Warning(${file}:$.): contents before sections\n";
+			print STDERR "${file}:$.: warning: contents before sections\n";
 			++$warnings;
 		    }
 		    dump_section($file, $section, xml_escape($contents));
@@ -2461,7 +2461,7 @@ sub process_file($) {
 		}
 		# look for doc_com + <text> + doc_end:
 		if ($_ =~ m'\s*\*\s*[a-zA-Z_0-9:\.]+\*/') {
-		    print STDERR "Warning(${file}:$.): suspicious ending line: $_";
+		    print STDERR "${file}:$.: warning: suspicious ending line: $_";
 		    ++$warnings;
 		}
 
@@ -2491,7 +2491,7 @@ sub process_file($) {
 		}
 	    } else {
 		# i dont know - bad line?  ignore.
-		print STDERR "Warning(${file}:$.): bad line: $_";
+		print STDERR "${file}:$.: warning: bad line: $_";
 		++$warnings;
 	    }
 	} elsif ($state == 3) {	# scanning for function '{' (end of prototype)
@@ -2547,7 +2547,7 @@ sub process_file($) {
 	}
     }
     if ($initial_section_counter == $section_counter) {
-	print STDERR "Warning(${file}): no structured comments found\n";
+	print STDERR "${file}:1: warning: no structured comments found\n";
 	if (($function_only == 1) && ($show_not_found == 1)) {
 	    print STDERR "    Was looking for '$_'.\n" for keys %function_table;
 	}
-- 
2.1.2

