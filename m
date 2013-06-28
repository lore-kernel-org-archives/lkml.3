Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab3F1QEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:04:44 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46503 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751230Ab3F1QEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:04:42 -0400
Message-ID: <1372435479.29380.11.camel@joe-AO722>
Subject: Re: [PATCH net-next v3 1/2] lib: vsprintf: add IPv4/v6 generic
 %p[Ii]S[pfs] format specifier
From: Joe Perches <joe@perches.com>
To: Daniel Borkmann <dborkman@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 28 Jun 2013 09:04:39 -0700
In-Reply-To: <51CDB183.1070209@redhat.com>
References: <1372421131-1672-1-git-send-email-dborkman@redhat.com>
	 <1372421131-1672-2-git-send-email-dborkman@redhat.com>
	 <1372434289.29380.6.camel@joe-AO722> <51CDB183.1070209@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-28 at 17:53 +0200, Daniel Borkmann wrote:
> On 06/28/2013 05:44 PM, Joe Perches wrote:
> > On Fri, 2013-06-28 at 14:05 +0200, Daniel Borkmann wrote:
> >> In order to avoid making code that deals with printing both, IPv4 and
> >> IPv6 addresses, unnecessary complicated as for example ...
[]
> > Should any other include other than net/addrconf be needed?
> I'm not sure I understand this question.

the #include <net/addrconf.h> indirectly
includes <linux/in.h> and <linux/in6.h>
but because this now uses struct sockaddr and family
it may be more sensible to directly include those.

No worries really, it works now.

> >> +char *ip6_addr_string_sa(char *buf, char *end, const struct sockaddr_in6 *sa,
> >> +			 struct printf_spec spec, const char *fmt)
> >> +{
> > []
> >> +	char fmt6[2] = { fmt[0], '6'};
> >
> > This looks odd to me.  why not use a bool compressed
> > flag and identify this before the isalpha loop and not
> > have fmt6 at all?
> 
> Well, we have a bool called 'have_c' that identifies if 'c' was specified. To have
> the same behaviour as with %pI6, this is used to create a temporary fmt that we then
> can pass to ip6_string(). If you look at ip6_addr_string(), it's done the same way,

It's a little different than that.

> and by that, we stay compatible in behaviour.

That's slightly tricky, ip6_addr_string just needs "I" or "i"

But, your implementation, your choice,

cheers, Joe

