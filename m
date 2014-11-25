Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbaKYTSO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 14:18:14 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:48451 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaKYTSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 14:18:11 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Miller <davem@davemloft.net>
Cc: josh@joshtriplett.org, rdunlap@infradead.org, pieter@boesman.nl,
        alexander.h.duyck@intel.com, viro@zeniv.linux.org.uk, ast@plumgrid.com,
        akpm@linux-foundation.org, beber@meleeweb.net,
        catalina.mocanu@gmail.com, dborkman@redhat.com, edumazet@google.com,
        fabf@skynet.be, fuse-devel@lists.sourceforge.net, geert@linux-m68k.org,
        hughd@google.com, iulia.manda21@gmail.com, JBeulich@suse.com,
        bfields@fieldses.org, jlayton@poochiereds.net,
        linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        mcgrof@suse.com, mattst88@gmail.com, mgorman@suse.de, mst@redhat.com,
        miklos@szeredi.hu, netdev@vger.kernel.org, oleg@redhat.com,
        Paul.Durrant@citrix.com, paulmck@linux.vnet.ibm.com,
        pefoley2@pefoley.com, tgraf@suug.ch, therbert@google.com,
        trond.myklebust@primarydata.com, willemb@google.com,
        xiaoguangrong@linux.vnet.ibm.com, zhenglong.cai@cs2c.com.cn
References: <5474ABB6.3030400@infradead.org>
	<20141125.121305.2094097848188324942.davem@davemloft.net>
	<20141125185310.GA24891@cloud>
	<20141125.140441.401150380839514113.davem@davemloft.net>
Date: Tue, 25 Nov 2014 13:16:44 -0600
In-Reply-To: <20141125.140441.401150380839514113.davem@davemloft.net> (David
	Miller's message of "Tue, 25 Nov 2014 14:04:41 -0500 (EST)")
Message-ID: <87egsr9jkz.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19StYbgHt02NYawOgjn5yB7RSu+Xvy2uys=
X-SA-Exim-Connect-IP: 97.121.92.161
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;David Miller <davem@davemloft.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 228 ms - load_scoreonly_sql: 0.21 (0.1%),
	signal_user_changed: 7 (2.9%), b_tie_ro: 4.7 (2.0%), parse: 1.08 (0.5%),
	extract_message_metadata: 14 (6.2%), get_uri_detail_list: 0.79 (0.3%),
	tests_pri_-1000: 9 (3.8%), tests_pri_-950: 1.20 (0.5%), tests_pri_-900: 1.08
	(0.5%), tests_pri_-400: 23 (10.1%), check_bayes: 22 (9.6%), b_tokenize: 6
	(2.7%), b_tok_get_all: 8 (3.4%), b_comp_prob: 1.97 (0.9%), b_tok_touch_all:
	3.3 (1.5%), b_finish: 0.93 (0.4%), tests_pri_0: 162 (71.0%), tests_pri_500: 6
	(2.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v4 0/7] kernel tinification: optionally compile out splice family of syscalls (splice, vmsplice, tee and sendfile)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: josh@joshtriplett.org
> Date: Tue, 25 Nov 2014 10:53:10 -0800
>
>> It's not a "slippery slope"; it's been our standard practice for ages.
>
> We've never put an entire class of generic system calls behind
> a config option.

CONFIG_SYSVIPC has been in the kernel as long as I can remember.

I seem to remember a plan to remove that code once userspace had
finished migrating to more unixy interfaces to ipc.  But in 20 years
that migration does does not seem to have finished, or even look
like it ever will.

But if we started a slippery slope it was long long ago.

Eric
