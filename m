Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757768Ab3BRX7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 18:59:09 -0500
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:63258 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757617Ab3BRX7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 18:59:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=HGil6fmmUsrCv6xBL/dDek5MKcLCm9YN
	1Clj+eOz0BvBkxL5uD+Q9/g9/Cer9SCkIAs0K4TK6q4oaeZFMyN1+v32TAcoPIui
	zze2Z7L6iBIypYwo9WcyYmUnKACM+qY/42nwKWo2uu26jInVtxO0WndEhH9OGsXw
	FE97ODMnZyw=
From: Junio C Hamano <gitster@pobox.com>
To: Matthieu Moy <Matthieu.Moy@grenoble-inp.fr>
Cc: git@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Git v1.8.2-rc0
References: <7vk3q6e94s.fsf@alter.siamese.dyndns.org>
 <vpq4nh9v5an.fsf@grenoble-inp.fr> <7vobfh8bjc.fsf@alter.siamese.dyndns.org>
Date: Mon, 18 Feb 2013 15:59:04 -0800
In-Reply-To: <7vobfh8bjc.fsf@alter.siamese.dyndns.org> (Junio C. Hamano's
 message of "Mon, 18 Feb 2013 15:09:11 -0800")
Message-ID: <7vk3q58987.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 2D70F6A4-7A27-11E2-89BA-21622E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano <gitster@pobox.com> writes:

>> I don't understand: wasn't this supposed to happen in Git 2.0? Did you
>> mean "In the upcoming major release (tentatively called *2.0*)"?
>
> Thanks.  I am not sure what I was thinking.  Perhaps when we started
> this cycle we did want to merge the push-2.0-default-to-simple series
>
> Will update.
>
>> Also, you may want to mention the argumentless "git add -u" change too.
>> It currently has an item below, but this is a future
>> backward-incompatible change so it may deserve to appear in this section
>> too.

OK, let's do this.  Thanks for sharp eyes.

 Documentation/RelNotes/1.8.2.txt | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/Documentation/RelNotes/1.8.2.txt b/Documentation/RelNotes/1.8.2.txt
index a5a1d4e..a287f24 100644
--- a/Documentation/RelNotes/1.8.2.txt
+++ b/Documentation/RelNotes/1.8.2.txt
@@ -4,8 +4,8 @@ Git v1.8.2 Release Notes
 Backward compatibility notes
 ----------------------------
 
-In the upcoming major release (tentatively called 1.8.2), we will
-change the behavior of the "git push" command.
+In the next major release Git 2.0 (not *this* one), we will change the
+behavior of the "git push" command.
 
 When "git push [$there]" does not say what to push, we have used the
 traditional "matching" semantics so far (all your branches were sent
@@ -22,6 +22,18 @@ that the old tag v1.2.3 points at.  This was found to be error prone
 and starting with this release, any attempt to update an existing
 ref under refs/tags/ hierarchy will fail, without "--force".
 
+When "git add -u" and "git add -A", that does not specify what paths
+to add on the command line, is run from inside a subdirectory, the
+scope of the operation has always been limited to the subirectory.
+Many users found this counter-intuitive, given that "git commit -a"
+and other commands operate on the entire tree regardless of where you
+are. In this release, these commands give warning in such a case and
+encourage the user to say "git add -u/-A ." instead when restricting
+the scope to the current directory. At Git 2.0 (not *this* one), we
+plan to change these commands without pathspec to operate on the
+entire tree, and training your fingers to type "." will protect you
+against the future change.
+
 
 Updates since v1.8.1
 --------------------
