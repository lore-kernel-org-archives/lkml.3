Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaEETWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 15:22:31 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:37582 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaEETWa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 15:22:30 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH] ftrace function-graph: print the function name on
 all } lines
Thread-Topic: [RFC PATCH] ftrace function-graph: print the function name on
 all } lines
Thread-Index: Ac9mODNtz2lzmTzpTXeVV8s0zTG8XgABRmyAAJYLinA=
Date: Mon, 5 May 2014 19:21:03 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402956EEB76B@G9W0745.americas.hpqcorp.net>
References: <94D0CD8314A33A4D9D801C0FE68B402956EE7D16@G9W0745.americas.hpqcorp.net>
 <20140502153249.1ee6aadd@gandalf.local.home>
In-Reply-To: <20140502153249.1ee6aadd@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Steven Rostedt [mailto:rostedt@goodmis.org]
> ...
> Yes it is too cluttered. Please make this a tracing option that is
> default off.

The TRACE_GRAPH_PRINT_xx macros exist in two places:
* trace.h has one set
* trace_functions_graph.c has redefinitions of them and adds 
  TRACE_GRAPH_PRINT_IRQS.  

The new macro will only be used inside trace_functions_graph.c. 
That is true of some of the others like TRACE_GRAPH_PRINT_OVERRUN, 
so doesn't seem to be the guiding principle for separate sets.

Should the new one be added to both places, or should the 
duplicate definitions in trace_functions_graph.c be removed?

trace_functions_graph.c:
#include "trace.h"
...
/* Flag options */
#define TRACE_GRAPH_PRINT_OVERRUN       0x1
#define TRACE_GRAPH_PRINT_CPU           0x2
#define TRACE_GRAPH_PRINT_OVERHEAD      0x4
#define TRACE_GRAPH_PRINT_PROC          0x8
#define TRACE_GRAPH_PRINT_DURATION      0x10
#define TRACE_GRAPH_PRINT_ABS_TIME      0x20
#define TRACE_GRAPH_PRINT_IRQS          0x40
#define TRACE_GRAPH_PRINT_TAIL          0x80 /* <-- new */

trace.h:
/* Flag options */
#define TRACE_GRAPH_PRINT_OVERRUN       0x1
#define TRACE_GRAPH_PRINT_CPU           0x2
#define TRACE_GRAPH_PRINT_OVERHEAD      0x4
#define TRACE_GRAPH_PRINT_PROC          0x8
#define TRACE_GRAPH_PRINT_DURATION      0x10
#define TRACE_GRAPH_PRINT_ABS_TIME      0x20
#define TRACE_GRAPH_PRINT_FILL_SHIFT    28
#define TRACE_GRAPH_PRINT_FILL_MASK     (0x3 << TRACE_GRAPH_PRINT_FILL_SHIFT)

---
Rob Elliott    HP Server Storage

