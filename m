Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233Ab3DYLgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 07:36:22 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:50781 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758152Ab3DYLgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 07:36:20 -0400
MIME-Version: 1.0
In-Reply-To: <5179130D.7080707@redhat.com>
References: <1366887900-24769-1-git-send-email-alex.mihai.c@gmail.com>
	<5179130D.7080707@redhat.com>
Date: Thu, 25 Apr 2013 14:36:19 +0300
Message-ID: <CAHG7+CCiumjx7bHuyXwrEJz3iWKzcE1yzni-sMZxs-Gt-9hWaw@mail.gmail.com>
Subject: Re: [PATCH 0/3 RFC v2] selftests: Basic framework for tests
From: Alexandru Copot <alex.mihai.c@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        akpm@linux-foundation.org, davem@davemloft.net, willemb@google.com,
        ebiederm@xmission.com, gorcunov@openvz.org, palewis@adobe.com,
        edumazet@google.com, Daniel Baluta <dbaluta@ixiacom.com>
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 2:27 PM, Daniel Borkmann <dborkman@redhat.com> wrote:
>> Signed-of-by Alexandru Copot <alex.mihai.c@gmail.com>
>
>
> It's: Signed-off-by: Alexandru Copot <alex.mihai.c@gmail.com>
>
> You have this wrong in all your patches.

I know, it was copy-pasted and I saw it just after sending. But for now
it's fine, these are just RFCs.

> Also, in patches 1-3 a proper commit message would be nice, i.e. in
> patch 1 when you add the library that everyone should use. It could be
> that your cover letter will not go into the Git history, thus people
> will only see you empty commit bodies.

You are right, I just thought the code was small enough to not
require a description.

Thanks!
Alex

On Thu, Apr 25, 2013 at 2:27 PM, Daniel Borkmann <dborkman@redhat.com> wrote:
> On 04/25/2013 01:04 PM, Alexandru Copot wrote:
>>
>> This series adds a generic test abstraction that can make
>> writing testcases easier. A generic_test structure is
>> used to define a test and its methods: prepare, run, cleanup.
>>
>> This is a generic implementation so it was placed in selftests/lib.
>>
>> The second patch updates the socket tests to use the
>> new framework and the third patch creates new tests
>> for [set/get]sockopt with some IPV6_* options.
>
>
> This already looks better than the previous one. I will probably go
> a bit more in depth through the code in the evening. A couple of minor
> general items I can already tell you:
>
>> Signed-of-by Alexandru Copot <alex.mihai.c@gmail.com>
>
>
> It's: Signed-off-by: Alexandru Copot <alex.mihai.c@gmail.com>
>
> You have this wrong in all your patches.
>
> Also, in patches 1-3 a proper commit message would be nice, i.e. in
> patch 1 when you add the library that everyone should use. It could be
> that your cover letter will not go into the Git history, thus people
> will only see you empty commit bodies.
>
>
>> Cc: Daniel Baluta <dbaluta@ixiacom.com>
>>
>> Changes since v1:
>>   - moved the implementation to selftests/lib
>>   - use goto instead of directly returning
>>
>> Alexandru Copot (3):
>>    selftests: introduce testing abstractions
>>    selftests/net: update socket test to use new testing framework
>>    selftests/net: add socket options test with IPv6 testcases
>>
>>   tools/testing/selftests/Makefile             |   3 +-
>>   tools/testing/selftests/lib/Makefile         |  14 ++
>>   tools/testing/selftests/lib/selftests.c      |  57 +++++++++
>>   tools/testing/selftests/lib/selftests.h      |  67 ++++++++++
>>   tools/testing/selftests/net/Makefile         |  17 ++-
>>   tools/testing/selftests/net/run_netsocktests |  10 ++
>>   tools/testing/selftests/net/socket.c         | 108 +++++++++++-----
>>   tools/testing/selftests/net/sockopt.c        | 185
>> +++++++++++++++++++++++++++
>>   8 files changed, 425 insertions(+), 36 deletions(-)
>>   create mode 100644 tools/testing/selftests/lib/Makefile
>>   create mode 100644 tools/testing/selftests/lib/selftests.c
>>   create mode 100644 tools/testing/selftests/lib/selftests.h
>>   create mode 100644 tools/testing/selftests/net/sockopt.c
