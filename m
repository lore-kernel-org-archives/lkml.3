Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbaJBTqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 15:46:25 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:41292 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbaJBTqX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 15:46:23 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Network Development <netdev@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <cwang@twopensource.com>
References: <1411478430-4989-1-git-send-email-nicolas.dichtel@6wind.com>
	<87ppei45ig.fsf@x220.int.ebiederm.org>
	<CALCETrX5e0cp4QFCv1eAqR1hjoROU9Rh=cRos9U35DaR-py3Eg@mail.gmail.com>
	<87y4t61a6v.fsf@x220.int.ebiederm.org> <54294B4E.70501@6wind.com>
	<87y4t2gtd0.fsf@x220.int.ebiederm.org> <542D5726.8070308@6wind.com>
	<8761g2nurx.fsf@x220.int.ebiederm.org>
	<CALCETrWxqzUF1x+TmW5G4kuHPP+sUtiRaT6dpZ0mQTJ217QB5w@mail.gmail.com>
Date: Thu, 02 Oct 2014 12:45:54 -0700
In-Reply-To: <CALCETrWxqzUF1x+TmW5G4kuHPP+sUtiRaT6dpZ0mQTJ217QB5w@mail.gmail.com>
	(Andy Lutomirski's message of "Thu, 2 Oct 2014 12:31:30 -0700")
Message-ID: <877g0il0gd.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-AID: U2FsdGVkX1/nKerOGNM0vv9G75hWKdIRC14C8dlqOXo=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2975]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1057 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 2.7 (0.3%), b_tie_ro: 1.80 (0.2%), parse: 1.06 (0.1%),
	extract_message_metadata: 39 (3.7%), get_uri_detail_list: 3.8 (0.4%),
	tests_pri_-1000: 25 (2.4%), tests_pri_-950: 1.64 (0.2%), tests_pri_-900: 1.42
	(0.1%), tests_pri_-400: 48 (4.5%), check_bayes: 47 (4.4%), b_tokenize: 23
	(2.2%), b_tok_get_all: 9 (0.9%), b_comp_prob: 3.6 (0.3%), b_tok_touch_all:
	1.77 (0.2%), b_finish: 0.62 (0.1%), tests_pri_0: 916 (86.7%), tests_pri_500:
	6 (0.6%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [RFC PATCH net-next v2 0/5] netns: allow to identify peer netns
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On Thu, Oct 2, 2014 at 12:20 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> Nicolas Dichtel <nicolas.dichtel@6wind.com> writes:
>>
>>> Le 29/09/2014 20:43, Eric W. Biederman a écrit :
>>>> Nicolas Dichtel <nicolas.dichtel@6wind.com> writes:
>>>>
>>>>> Le 26/09/2014 20:57, Eric W. Biederman a écrit :
>>>>>> Andy Lutomirski <luto@amacapital.net> writes:
>>>>>>
>>>>>>> On Fri, Sep 26, 2014 at 11:10 AM, Eric W. Biederman
>>>>>>> <ebiederm@xmission.com> wrote:
>>>>>>>> I see two ways to go with this.
>>>>>>>>
>>>>>>>> - A per network namespace table to that you can store ids for ``peer''
>>>>>>>>     network namespaces.  The table would need to be populated manually by
>>>>>>>>     the likes of ip netns add.
>>>>>>>>
>>>>>>>>     That flips the order of assignment and makes this idea solid.
>>>>> I have a preference for this solution, because it allows to have a full
>>>>> broadcast messages. When you have a lot of network interfaces (> 10k),
>>>>> it saves a lot of time to avoid another request to get all informations.
>>>>
>>>> My practical question is how often does it happen that we care?
>>> In fact, I don't think that scenarii with a lot of netns have a full mesh of
>>> x-netns interfaces. It will be more one "link" netns with the physical
>>> interface and all other with one interface with the link part in this "link"
>>> netns. Hence, only one nsid is needing in each netns.
>>
>> I will buy that a full mesh is unlikely.
>>
>> For people doing simulations anything physical has a limited number of
>> links.
>>
>> For people wanting all to all connectivity setting up an internal
>> macvlan (or the equivalent) is likely much simpler and more efficient
>> that a full mesh.
>>
>> So the question in my mind is how do we create these identifiers at need
>> (when we create the cross network namespace links) instead of at network
>> namespace creation time.  I don't see an answer to that in your patches,
>> and perhaps it obvious.
>>
>
> I wonder whether part of the problem is that we're thinking about
> scoping wrong.  What if we made the hierarchy more explicit?
>
> For example, we could give each netns an admin-assigned identifier
> (e.g. a 64-bit number, maybe required to be unique, maybe not)
> relative to its containing userns.  Then we could come up with a way
> to identify user namespaces (i.e. inode number relative to containing
> user ns, if that's well-defined).

If as suggested we only assign ids when a tunnel (or equivalent) is
created between two network namespaces the space cost is a non-issue.
The ids become at worst a constant factor addition to the cost of the
tunnel.

To keep things simple we may want to assign a free id (if one does not
exist) when we connect a tunnel to a network namespace.

> From user code's perspective, netnses that are in the requester's
> userns or its descendents are identified by a path through a (possibly
> zero-length) sequence of userns ids followed by a netns id.  Netnses
> outside the requester's userns hierarchy cannot be named at all.
>
> Would this make sense? 

Nope.  What happens if I migrate 2 of the 4 network namespaces in a user
namespace?  The migration potentially fails.  Application migration does
not require user namespace migration.

Eric
