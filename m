Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751125AbaKYUCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 15:02:40 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:60615 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaKYUCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 15:02:37 -0500
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
References: <20141125185310.GA24891@cloud>
	<20141125.140441.401150380839514113.davem@davemloft.net>
	<87egsr9jkz.fsf@x220.int.ebiederm.org>
	<20141125.142741.1620673255148724338.davem@davemloft.net>
Date: Tue, 25 Nov 2014 14:01:15 -0600
In-Reply-To: <20141125.142741.1620673255148724338.davem@davemloft.net> (David
	Miller's message of "Tue, 25 Nov 2014 14:27:41 -0500 (EST)")
Message-ID: <87y4qz82yc.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/v4Nq7Kga/mzZ1oC+sZSpAlY1jQKQOCjY=
X-SA-Exim-Connect-IP: 97.121.92.161
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;David Miller <davem@davemloft.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 283 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 2.7 (0.9%), b_tie_ro: 1.82 (0.6%), parse: 0.88 (0.3%),
	extract_message_metadata: 21 (7.3%), get_uri_detail_list: 1.56 (0.6%),
	tests_pri_-1000: 6 (2.1%), tests_pri_-950: 1.24 (0.4%), tests_pri_-900: 1.18
	(0.4%), tests_pri_-400: 33 (11.6%), check_bayes: 32 (11.1%), b_tokenize: 10
	(3.6%), b_tok_get_all: 10 (3.6%), b_comp_prob: 3.0 (1.1%), b_tok_touch_all: 5
	(1.8%), b_finish: 0.80 (0.3%), tests_pri_0: 209 (73.8%), tests_pri_500: 6
	(2.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v4 0/7] kernel tinification: optionally compile out splice family of syscalls (splice, vmsplice, tee and sendfile)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> From: ebiederm@xmission.com (Eric W. Biederman)
> Date: Tue, 25 Nov 2014 13:16:44 -0600
>
>> David Miller <davem@davemloft.net> writes:
>> 
>>> From: josh@joshtriplett.org
>>> Date: Tue, 25 Nov 2014 10:53:10 -0800
>>>
>>>> It's not a "slippery slope"; it's been our standard practice for ages.
>>>
>>> We've never put an entire class of generic system calls behind
>>> a config option.
>> 
>> CONFIG_SYSVIPC has been in the kernel as long as I can remember.
>> 
>> I seem to remember a plan to remove that code once userspace had
>> finished migrating to more unixy interfaces to ipc.  But in 20 years
>> that migration does does not seem to have finished, or even look
>> like it ever will.
>> 
>> But if we started a slippery slope it was long long ago.
>
> Fair enough.
>
> Would be amusing if these tiny systems have it enabled.

It would.

In practice when I was playing in that space I had a hard time
justifying CONFIG_NET and CONFIG_INET.  Despite writing a network
bootloader to use with kexec.

Eric
