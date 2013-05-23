Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759822Ab3EWP1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:27:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12773 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759801Ab3EWP1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:27:19 -0400
X-Authority-Analysis: v=2.0 cv=IZAFqBWa c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=rKI68ldaRsEA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=54K5z7jWVYMA:10 a=JaTbTE50uwbIEMqLdRUA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1369322836.6828.199.camel@gandalf.local.home>
Subject: Re: [PATCH] mm: fix up a spurious page fault whenever it happens
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rik van Riel <riel@redhat.com>, Stanislav Meduna <stano@meduna.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Hai Huang <hhuang@redhat.com>
Date: Thu, 23 May 2013 11:27:16 -0400
In-Reply-To: <519E3089.8040701@zytor.com>
References: <5195ED8B.7060002@meduna.org>
	   <1369183168.6828.168.camel@gandalf.local.home>
	   <519CBB30.3060200@redhat.com>
	   <CA+55aFxMqvDvcVtLW-yD2PuU_CcjPOC30Zk07Kuk6S25WCzbHQ@mail.gmail.com>
	   <20130522134111.33a695c5@cuia.bos.redhat.com>
	  <519D08B0.8050707@meduna.org>
	  <1369246316.6828.176.camel@gandalf.local.home>
	  <519D0CAB.7020800@meduna.org> <519D0FF8.5080200@redhat.com>
	  <519D118B.6010306@zytor.com> <519D11BF.5000604@redhat.com>
	  <519DCE2A.4010801@meduna.org> <519E095A.4000105@redhat.com>
	 <1369315769.6828.198.camel@gandalf.local.home> <519E3089.8040701@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-23 at 08:06 -0700, H. Peter Anvin wrote:

> We don't even need the jump_label infrastructure -- we have
> static_cpu_has*() which actually predates jump_label although it uses
> the same underlying ideas.

Ah right. I wonder if it would be worth consolidating a lot of these
"modifying of code" infrastructures. Which reminds me, I need to update
text_poke() to do things similar to what ftrace does, and get rid of the
stop machine code.

-- Steve


