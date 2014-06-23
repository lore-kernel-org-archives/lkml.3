Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbaFWBaV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 21:30:21 -0400
Received: from smtprelay0138.hostedemail.com ([216.40.44.138]:44345 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751115AbaFWBaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 21:30:19 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:966:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4385:4470:5007:6119:6120:7652:7807:8660:8985:9025:10004:10400:10848:11232:11658:11914:12043:12517:12519:12555:12740:13069:13148:13230:13
X-HE-Tag: field82_26dda311c455
X-Filterd-Recvd-Size: 2131
Message-ID: <1403487015.18747.23.camel@joe-AO725>
Subject: Re: [RFC PATCH 0/3] Mark literal strings in __init / __exit code
From: Joe Perches <joe@perches.com>
To: Mathias Krause <minipli@googlemail.com>,
        David Daney <david.daney@cavium.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>
Date: Sun, 22 Jun 2014 18:30:15 -0700
In-Reply-To: <1403477209-14612-1-git-send-email-minipli@googlemail.com>
References: <1403477209-14612-1-git-send-email-minipli@googlemail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-23 at 00:46 +0200, Mathias Krause wrote:
> This RFC series tries to address the problem of dangling strings of
> __init functions after initialization, as well as __exit strings for
> code not even included in the final kernel image. The code might get
> freed, but the format strings are not.
> 
> One solution to the problem might be to declare variables in the code
> and mark those variables as __initconst. That, though, makes the code
> ugly, as can be seen, e.g., in drivers/hwmon/w83627ehf.c -- a pile of
> 'static const char[] __initconst' lines just for the pr_info() call.

Another solution might be, as David Daney suggested, using
gcc 4.5+ plug-ins to extract these format strings and
const char * arrays into specific sections automatically.

https://lkml.org/lkml/2009/7/21/483

Seems feasible, but there might be a negative of string
duplication in multiple sections that would otherwise
be consolidated into a single object.

