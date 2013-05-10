Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab3EJPfB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 11:35:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811Ab3EJPfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 11:35:00 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] perf: Expand definition of sysfs format attribute
Date: Fri, 10 May 2013 17:33:00 +0200
Message-Id: <1368199980-20283-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Ellerman <michael@ellerman.id.au>

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
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
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
-- 
1.7.11.7

