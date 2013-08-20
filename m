Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485Ab3HTO2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 10:28:22 -0400
Received: from smtp107.biz.mail.ne1.yahoo.com ([98.138.207.14]:46818 "HELO
	smtp107.biz.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751193Ab3HTO2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 10:28:18 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: KNRZra8VM1mglmna5O0Pq5EBNODllFVNX_wabZSfNDwVTzo
 4_etidb06NU32u07999SfZykT7Pe232kkTvFlgjNJC_ndKoR8BQgq22O4iwu
 sM4a1qquaM4nSdndX5UcS19wfOgd2L9QBVIy2r3fbW7OEQb7DF9pvTFt0Unt
 v4jUXcXgnCIbwouKVq93.VjYGdmCjjomAG4qweL7_ouWDQ_XfJ54mo89qxeJ
 Z9PWwvq2d3ZdhdxNC8L2L3QXaO_fv4gxhwjTw4gwVyXTXfdPEmuZhMRB6Y8C
 rS6zYW55xDIdDoIjnDBm3qzPr2LklGOYWmzhWK4nClEYoBAOlO34vg5yt6gY
 QEMT6kUjcmfPjcyiIapssXoJdipIjOtteiaELvzgB300oCMlucwQhtDRTeQD
 KH69qnEb16aAR8Ldse41dGGVtvnD6crJfRe_UyWvwgQgaVHjVyoPGvRhJH1p
 zSyDImuBCW7sidWEEQdinCWLAwkorZuOoMwzHct6zWmGNlNHCyp0T37UFEoW
 7TZje_FX1TjI4mGm86U0g8lwKq6TloaNJH3ejSY.R_x5OzIRk6w--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with )
        by smtp107.biz.mail.ne1.yahoo.com with SMTP; 20 Aug 2013 07:28:17 -0700 PDT
Message-ID: <52137CFF.70601@schaufler-ca.com>
Date: Tue, 20 Aug 2013 07:28:15 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Cong Wang <amwang@redhat.com>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        james.l.morris@oracle.com, sds@tycho.nsa.gov, eparis@parisplace.org,
        pmoore@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [Patch net-next v3 9/9] selinux: use generic union inet_addr
References: <1376907278-26377-1-git-send-email-amwang@redhat.com>  <1376907278-26377-10-git-send-email-amwang@redhat.com>  <52127336.3080209@schaufler-ca.com>  <20130819.125026.636442915180863272.davem@davemloft.net>  <5212915F.20905@schaufler-ca.com> <1377003677.13412.5.camel@cr0>
In-Reply-To: <1377003677.13412.5.camel@cr0>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/20/2013 6:01 AM, Cong Wang wrote:
> On Mon, 2013-08-19 at 14:42 -0700, Casey Schaufler wrote:
>> Well, they certainly don't appear to add any value on their own.
>> I also generally oppose doing clever things with data structures. 
> If you want to implement same thing for 5+ times,

Those 5+ implementations are already there, and already work.
A 6th implementation to replace known working code is just churn
unless it provides some additional value. Making the code "better"
does not itself add value. 

>  yes, it has no value
> for you. Enjoy the following code in current tree:
>
> union nf_inet_addr;
> union sctp_addr;
> union vxlan_addr; (in my VXLAN IPv6 patches, search email archives)
> struct br_mdb_entry::addr;
> union inet_addr; (in netpoll.h)
>
> And may I tell you the last three are all from me? ;-)

I do use and enjoy all of these implementations! Thank you
for the fine implementations. In the end, if you're maintaining
the code it's your call. I question change that does not have
an obvious purpose because statistically every 10th change has
a bug.

Now that I know what the change is for I am fine with it. I
like seeing reasons up front.

>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

