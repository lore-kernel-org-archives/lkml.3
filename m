Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035AbaFSMEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 08:04:16 -0400
Received: from emvm-gh1-uea09.nsa.gov ([63.239.67.10]:58131 "EHLO
	emvm-gh1-uea09.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757238AbaFSMEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 08:04:15 -0400
X-TM-IMSS-Message-ID: <0c95d3c90016528b@nsa.gov>
Message-ID: <53A2D1A2.9050900@tycho.nsa.gov>
Date: Thu, 19 Jun 2014 08:03:46 -0400
From: Stephen Smalley <sds@tycho.nsa.gov>
Organization: National Security Agency
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Paul Moore <paul@paul-moore.com>, Namhyung Kim <namhyung@kernel.org>
CC: Eric Paris <eparis@parisplace.org>, selinux@tycho.nsa.gov,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] selinux: simple cleanup for cond_read_node()
References: <1402762742-2808-1-git-send-email-namhyung@kernel.org> <1719649.5PAcuqR8Pm@sifl>
In-Reply-To: <1719649.5PAcuqR8Pm@sifl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 03:36 PM, Paul Moore wrote:
> On Sunday, June 15, 2014 01:19:01 AM Namhyung Kim wrote:
>> The node->cur_state and len can be read in a single call of next_entry().
>> And setting len before reading is a dead write so can be eliminated.
>>
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> ---
>>  security/selinux/ss/conditional.c | 9 ++-------
>>  1 file changed, 2 insertions(+), 7 deletions(-)
>>
>> diff --git a/security/selinux/ss/conditional.c
>> b/security/selinux/ss/conditional.c index 377d148e7157..4766a38fae9a 100644
>> --- a/security/selinux/ss/conditional.c
>> +++ b/security/selinux/ss/conditional.c
>> @@ -402,19 +402,14 @@ static int cond_read_node(struct policydb *p, struct
>> cond_node *node, void *fp) int rc;
>>  	struct cond_expr *expr = NULL, *last = NULL;
>>
>> -	rc = next_entry(buf, fp, sizeof(u32));
>> +	rc = next_entry(buf, fp, sizeof(buf));
> 
> This is a bit nit-picky, but how about using "sizeof(u32) * 2"?  It is more 
> consistent with the rest of the function and helps underscore that we are 

Concur - I don't want to assume that the buf size is always the same as
the next read size (e.g. we sometimes use the same buf for multiple reads).



