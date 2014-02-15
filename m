Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbaBOE0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 23:26:40 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:3785 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751661AbaBOE0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 23:26:39 -0500
Date: Fri, 14 Feb 2014 23:26:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        akpm@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 39/48] powerpc: Replace __get_cpu_var uses
Message-ID: <20140214232636.0a683ca0@gandalf.local.home>
In-Reply-To: <1392436208.10050.22.camel@pasglop>
References: <20140214201841.826179349@linux.com>
	<20140214201908.082769265@linux.com>
	<1392436208.10050.22.camel@pasglop>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Feb 2014 14:50:08 +1100
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> For some reason Im still getting these as attachments instead of inline
> in the email, which makes reviewing a major PITA. Christoph, I'm not
> sure what you are doing wrong here but you should consider fixing it :-)

Get a better email client ;-)

They show up fine for me. Looking at the raw format, could it possibly
be the DKIM-Signature? Here's (most of) the header:

Return-Path: cl@linux.com
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on goliath
X-Spam-Level: 
X-Spam-Status: No, score=-0.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
	LOCAL_SUBJECT_PATCH,RCVD_IN_DNSWL_NONE autolearn=unavailable version=3.3.2
Delivered-To: rostedt@goodmis.org
X-FDA: 68539149672.07.nose31_2242917219f26
X-HE-Tag: nose31_2242917219f26
X-Filterd-Recvd-Size: 34239
Received: from mail.hover.com.cust.hostedemail.com [216.40.42.134]
	by goliath with IMAP (fetchmail-6.3.26)
	for <rostedt@localhost> (single-drop); Fri, 14 Feb 2014 15:23:03 -0500 (EST)
Received: from qmta09.emeryville.ca.mail.comcast.net (qmta09.emeryville.ca.mail.comcast.net [76.96.30.96])
	by imf20.hostedemail.com (Postfix) with ESMTP
	for <rostedt@goodmis.org>; Fri, 14 Feb 2014 20:20:35 +0000 (UTC)
Received: from omta15.emeryville.ca.mail.comcast.net ([76.96.30.71])
	by qmta09.emeryville.ca.mail.comcast.net with comcast
	id SKft1n0011Y3wxoA9LLbGd; Fri, 14 Feb 2014 20:20:35 +0000
Received: from gentwo.org ([98.213.233.247])
	by omta15.emeryville.ca.mail.comcast.net with comcast
	id SLLY1n0095Lw0ES8bLLZFV; Fri, 14 Feb 2014 20:20:34 +0000
Received: by gentwo.org (Postfix, from userid 1001)
	id 2941A68181; Fri, 14 Feb 2014 14:19:08 -0600 (CST)
Message-Id: <20140214201908.082769265@linux.com>
Date: Fri, 14 Feb 2014 14:19:20 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org,
 rostedt@goodmis.org,
 linux-kernel@vger.kernel.org,
 Ingo Molnar <mingo@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@linutronix.de>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 Paul Mackerras <paulus@samba.org>
Subject: [PATCH 39/48] powerpc: Replace __get_cpu_var uses
References: <20140214201841.826179349@linux.com>
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=this_powerpc
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=comcast.net;
	s=q20121106; t=1392409235;
	bh=3eMNjwtVIqOOdbqtLUxQGKw+WvtREJiNlp1vuKEVub8=;
	h=Received:Received:Received:Message-Id:Date:From:To:Subject:
	 Content-Type;
	b=AtOZLlCPJL9tvUnoSyw0qPmNQym1dGDConwMdjEnayz2rNubuobF/JYdewBUypgbZ
	 3sq/JQoBriYX8NsMHQhzZL4bh+7gM6OPWhGSIczq6MNuzFvw7E9MVTeX+t+yhVXMNG
	 O+sWkLbWkM18luLRPlJU7wD6ANEFrGgQvt7i1GqSrCVZ+qKgXq9brzu9NTsMp4ODzv
	 Djs9LTZEBTjbYxllW+16x+lV/Y6zY9LYQzsB6VEEpjO2J5Z6Wbk12K4puGL0rPPKoW
	 rpxrQjP44g+Tgr5iguuBUQAqIuzcgbDu3MtOwz+HllZuKiye+qQB+Eq/U5+CqtaIxl
	 FN9CB0XgHTDJA==


-- Steve
