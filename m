Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965440Ab3GCTdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:33:39 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:55526 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965294Ab3GCTdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:33:38 -0400
Date: Wed, 3 Jul 2013 15:39:10 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: linux-kernel@vger.kernel.org
cc: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: perf/Documentation/ABI -- add some documentation for perf_event
 sysfs usage
Message-ID: <alpine.DEB.2.10.1307031527390.12584@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add some documentation for the perf_event related
  /sys/bus/event_source/bus/devices/
files, since in theory it's a stable interface and the only
current documentation is some lex and yacc files in the
perf tools directory.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/Documentation/ABI/stable/sysfs-bus-event_source-devices b/Documentation/ABI/stable/sysfs-bus-event_source-devices
new file mode 100644
index 0000000..9ef862f
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-bus-event_source-devices
@@ -0,0 +1,39 @@
+What:		/sys/bus/event_source/bus/devices/*/events/*
+Date:		Oct 2012
+KernelVersion:	3.8
+Contact:	Jiri Olsa <jolsa@redhat.com>
+Description:
+		Each file in /sys/bus/event_source/bus/devices/*/events/
+		represents a predefined perf_event event.
+
+		The contents of the file are a string describing
+		fields to set when generating raw events for
+		the perf_event_open() system call.
+
+		The layout of the file is
+			attr=value[,attr=value]...
+		Where attr is the name of a bitfield described
+		in /sys/bus/event_source/bus/devices/*/format/*
+		and value is either a hex (starting with 0x) or decimal
+		value.
+
+
+What:		/sys/bus/event_source/bus/devices/*/format/*
+Date:		Oct 2012
+KernelVersion:	3.8
+Contact:	Jiri Olsa <jolsa@redhat.com>
+Description:
+		Each file in /sys/bus/event_source/bus/devices/*/format/
+		represents a description of a bitfield used when 
+		constructing raw perf_event_open() raw events.
+
+		The contents of the file are a string describing
+		the name of the field and its range.
+
+		The layout of the file is
+			field:low[-high]
+		Where field is the field name, low is the low bit
+		of the range, and the optional high value is the high
+		bit of the range.  The low and high values are base-10
+		integers.
+
