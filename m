Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369AbaLIQP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 11:15:29 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:54693 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296AbaLIQP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 11:15:26 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Lukasz Pawelczyk <havner@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, David Howells <dhowells@redhat.com>,
        Mark Rustad <mark.d.rustad@intel.com>,
        Juri Lelli <juri.lelli@gmail.com>, Richard Weinberger <richard@nod.at>,
        Daeseok Youn <daeseok.youn@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Rientjes <rientjes@google.com>,
        Alex Thorlton <athorlton@sgi.com>,
        Matthew Dempsky <mdempsky@chromium.org>,
        Kees Cook <keescook@chromium.org>,
        Nikolay Aleksandrov <nikolay@redhat.com>,
        Dario Faggioli <raistlin@linux.it>, Al Viro <viro@zeniv.linux.org.uk>,
        James Morris <james.l.morris@oracle.com>,
        "open list\:ABI\/API" <linux-api@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Moore <pmoore@redhat.com>,
        linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <1417096866-25563-1-git-send-email-l.pawelczyk@samsung.com>
	<1417096866-25563-2-git-send-email-l.pawelczyk@samsung.com>
	<CAFLxGvzw4N4QFv5Vg1dDf9pdRe+Szbevmqn5QNwjLHN4xrokCg@mail.gmail.com>
	<1417098928.1805.15.camel@samsung.com> <54773757.8090905@nod.at>
	<1417099455.1805.17.camel@samsung.com> <54773CE7.5040303@nod.at>
	<1417101060.1805.21.camel@samsung.com>
	<87d288zm3a.fsf@x220.int.ebiederm.org>
	<1417104439.1805.25.camel@samsung.com>
	<871tooy4nc.fsf@x220.int.ebiederm.org>
	<1417109911.1805.27.camel@samsung.com>
	<1417524193.1899.2.camel@samsung.com>
Date: Tue, 09 Dec 2014 10:13:04 -0600
In-Reply-To: <1417524193.1899.2.camel@samsung.com> (Lukasz Pawelczyk's message
	of "Tue, 02 Dec 2014 13:43:13 +0100")
Message-ID: <871to8n6nj.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/NdmTG92R+ZuqgEJdaur5GagO1nL8BbmY=
X-SA-Exim-Connect-IP: 67.3.210.55
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Lukasz Pawelczyk <l.pawelczyk@samsung.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1410 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 4.7 (0.3%), b_tie_ro: 3.9 (0.3%), parse: 0.91 (0.1%),
	extract_message_metadata: 16 (1.1%), get_uri_detail_list: 1.12 (0.1%),
	tests_pri_-1000: 9 (0.6%), tests_pri_-950: 1.58 (0.1%), tests_pri_-900: 1.37
	(0.1%), tests_pri_-400: 40 (2.9%), check_bayes: 39 (2.8%), b_tokenize: 12
	(0.8%), b_tok_get_all: 12 (0.8%), b_comp_prob: 2.8 (0.2%), b_tok_touch_all:
	4.6 (0.3%), b_finish: 0.85 (0.1%), tests_pri_0: 1326 (94.0%), tests_pri_500:
	7 (0.5%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [RFC] lsm: namespace hooks
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukasz Pawelczyk <l.pawelczyk@samsung.com> writes:

> On czw, 2014-11-27 at 18:38 +0100, Lukasz Pawelczyk wrote:
>> Right now the major issue I see is that LSM by itself is not defined how
>> it's going to behave. It's up to a specific LSM module.
>> 
>> E.g. within the Smack namespace filling the map is a privileged
>> operation. So by tying them up you cripple the ability to create a fully
>> working user namespace as an unprivileged process.
>
> Entertaining the idea that LSM namespace would be tied to user namespace
> (as you suggested) how do you see the limitation I described above?

If they are tied it means you wind up in a situation where there are no
labels you can set.

In general setting the uid and gid maps is also a privileged operations.

I really don't know what makes sense to do with lsms and namespaces
generically, but I do know that your lsm namespace patche were awkwards
and weird and seemed to be taking things in the wrong direction.

Eric
