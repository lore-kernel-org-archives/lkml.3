Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab3LGBUZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 20:20:25 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:48208 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab3LGBUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 20:20:23 -0500
Message-ID: <52A277CE.4080900@hitachi.com>
Date: Sat, 07 Dec 2013 10:20:14 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Petr Mladek <pmladek@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH v5 1/8] x86: allow to handle errors in text_poke function
 family
References: <1386076887-2655-1-git-send-email-pmladek@suse.cz> <1386076887-2655-2-git-send-email-pmladek@suse.cz>
In-Reply-To: <1386076887-2655-2-git-send-email-pmladek@suse.cz>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/03 22:21), Petr Mladek wrote:
> The text_poke functions called BUG() in case of error. This was too strict.
> There are situations when the system is still usable even when the patching
> has failed, for example when enabling the dynamic ftrace.
> 
> This commit modifies text_poke, text_poke_early, and text_poke_bp functions
> to return an error code instead calling BUG(). The code is returned instead
> of the patched address. The address was just copied from the first parameter,
> so it was no extra information. It has not been used anywhere yet.

Hmm, this change basically good for me. However, from the maintenance point
of view, I'd like to recommend you to introduce some wrappers for them
to check return code and just do BUG() instead of changing all call-site,
because except for the text_poke_bp, we can not rollback the code safely.
(e.g. text_poke() returns an error but text_poke_or_die() just calls BUG
when it fails)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


