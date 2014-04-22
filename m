Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaDVXpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 19:45:36 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:39782 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaDVXpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 19:45:34 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 22 Apr 2014 16:45:13 -0700
Message-ID: <CALCETrUWg+=pxPWTtH_Mk4j1eEbQdt_+AabcpuJCDg+HawtDaQ@mail.gmail.com>
Subject: Keyring mysteries
To: keyrings@linux-nfs.org, David Howells <dhowells@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some keyring mysteries.

If my uid is *not* 1001, and uid 1001 is not currently logged in but
uid 1001 will log in soon, this does terrible things:

$ keyctl newring _uid.1001 @us

In general, I do not understand how it is possible to use
find_keyring_by_name safely.  (This may need a CVE number assigned if
it's as bad as I think it may be.  I see no a priori reason that it
can't be used to trivially steal Kerberos credentials.)

What does it mean to revoke an entire keyring?  keyctl revoke @u seems
to do something odd.

Are you supposed to be able to recover from keyctl setperm @u 0?

What is a possessed key?  If I have KEY_LINK, does that mean I can
possess a key and possibly elevate my permissions?

What's up with key_fsuid_changed?  It looks like it's a giant security
hole in any case where it has any effect at all and setfsuid is being
used.  But maybe I don't understand the point.

Why doesn't key_change_session_keyring use prepare_creds?

Why do keyrings live in struct cred?  Especially, why is
thread_keyring in there?  I'd really like to get rid of that.

--Andy
