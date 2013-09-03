Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab3ICHg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 03:36:57 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:50499 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932482Ab3ICHgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 03:36:55 -0400
Subject: [RFC PATCH 0/2] Perf support to SDT markers
To: linux-kernel@vger.kernel.org
From: Hemant Kumar Shaw <hkshaw@linux.vnet.ibm.com>
Cc: srikar@linux.vnet.ibm.com, peterz@infradead.org, oleg@redhat.com,
        mingo@redhat.com, anton@redhat.com, systemtap@sourceware.org,
        masami.hiramatsu.pt@hitachi.com
Date: Tue, 03 Sep 2013 13:06:40 +0530
Message-ID: <20130903072944.4793.93584.stgit@hemant-fedora>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090307-1396-0000-0000-0000037F3A45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support to perf to list and probe into the SDT markers.
The first patch implements listing of all the SDT markers present in
the ELFs (executables or libraries). The SDT markers are present in the
.note.stapsdt section of the elf. That section can be traversed to list
all the markers. Recognition of markers follows the SystemTap approach.

The second patch will allow perf to probe into these markers. This is
done by writing the marker name and its offset into the
uprobe_events file in the tracing directory.
Then, perf tools can be used to analyze perf.data file.

---

Hemant Kumar (2):
      SDT markers listing by perf
      Support to perf to probe on SDT markers


 tools/perf/builtin-probe.c    |   33 ++++
 tools/perf/util/probe-event.c |   17 ++
 tools/perf/util/symbol-elf.c  |  317 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/symbol.h      |   24 +++
 4 files changed, 391 insertions(+)

-- 

