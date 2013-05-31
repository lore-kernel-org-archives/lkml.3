Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab3EaM0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:26:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57601 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab3EaMZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:25:56 -0400
Date: Fri, 31 May 2013 05:25:31 -0700
From: tip-bot for Michael Ellerman <tipbot@zytor.com>
Message-ID: <tip-fd851780e61ac36e8d59fe87cca01a2e673930ff@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, michael@ellerman.id.au, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, michael@ellerman.id.au, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1368199980-20283-1-git-send-email-jolsa@redhat.com>
References: <1368199980-20283-1-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Expand definition of sysfs format attribute
Git-Commit-ID: fd851780e61ac36e8d59fe87cca01a2e673930ff
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fd851780e61ac36e8d59fe87cca01a2e673930ff
Gitweb:     http://git.kernel.org/tip/fd851780e61ac36e8d59fe87cca01a2e673930ff
Author:     Michael Ellerman <michael@ellerman.id.au>
AuthorDate: Fri, 10 May 2013 17:33:00 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 May 2013 16:11:40 +0300

perf: Expand definition of sysfs format attribute

Make it explicit that the format attributes may define overlapping bit
ranges. Unfortunately this was left unspecified originally, and all the
examples show non-overlapping ranges. I don't believe this is an ABI
change, as we are defining something that was previously undefined, but
others may disagree.

The POWER8 PMU would like to define overlapping ranges, as bit ranges in
the event code have different meanings for certain events. It will also
allow us to define an overarching "event" field, that encompasses all
others.

As far as I can see perf is comfortable with this change, however I am
not sure if there are any other users of the interface.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1368199980-20283-1-git-send-email-jolsa@redhat.com
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 Documentation/ABI/testing/sysfs-bus-event_source-devices-format | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-format b/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
index 079afc7..77f47ff 100644
--- a/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
+++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-format
@@ -9,6 +9,12 @@ Description:
 		we want to export, so that userspace can deal with sane
 		name/value pairs.
 
+		Userspace must be prepared for the possibility that attributes
+		define overlapping bit ranges. For example:
+			attr1 = 'config:0-23'
+			attr2 = 'config:0-7'
+			attr3 = 'config:12-35'
+
 		Example: 'config1:1,6-10,44'
 		Defines contents of attribute that occupies bits 1,6-10,44 of
 		perf_event_attr::config1.
