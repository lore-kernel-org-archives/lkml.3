Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbaJGTwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:52:30 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:54232 "HELO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752470AbaJGTw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:52:29 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Oct 2014 15:52:28 EDT
MIME-Version: 1.0
In-Reply-To: <54341BD7.3070207@infradead.org>
References: <20141007194454.10502188@canb.auug.org.au>
	<54341BD7.3070207@infradead.org>
Date: Tue, 7 Oct 2014 12:45:19 -0700
Message-ID: <CACzMAJK+_GkDxSWpim764EafuDTgb3rAxNzMenNC1sP1wX7s9Q@mail.gmail.com>
Subject: Re: [ovs-dev] linux-next: Tree for Oct 7 (openvswitch)
From: Andy Zhou <azhou@nicira.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux-Next <linux-next@vger.kernel.org>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This issue should have been fixed with commit
7c5df8fa1921450d2210db9928f43cf4f414982c

Fix a openvswitch compilation error when CONFIG_INET is not set:

    =====================================================
       In file included from include/net/geneve.h:4:0,
                           from net/openvswitch/flow_netlink.c:45:
                          include/net/udp_tunnel.h: In function 'udp_tunnel_hand
                          >> include/net/udp_tunnel.h:100:2: error: implicit dec
                          >>      return iptunnel_handle_offloads(skb, udp_csum,
                          >>           ^
                          >>           >> include/net/udp_tunnel.h:100:2: warnin
                          >>           >>    cc1: some warnings being treated as

    =====================================================

    Reported-by: kbuild test robot <fengguang.wu@intel.com>
    Signed-off-by: Andy Zhou <azhou@nicira.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

On Tue, Oct 7, 2014 at 9:59 AM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 10/07/14 01:44, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20141003:
>>
>
> on i386 or x86_64:
>
> In file included from ../include/net/geneve.h:4:0,
>                  from ../net/openvswitch/flow_netlink.c:45:
> ../include/net/udp_tunnel.h: In function 'udp_tunnel_handle_offloads':
> ../include/net/udp_tunnel.h:100:2: error: implicit declaration of function 'iptunnel_handle_offloads' [-Werror=implicit-function-declaration]
>   return iptunnel_handle_offloads(skb, udp_csum, type);
>   ^
> ../include/net/udp_tunnel.h:100:2: warning: return makes pointer from integer without a cast [enabled by default]
>
>
>
> --
> ~Randy
> _______________________________________________
> dev mailing list
> dev@openvswitch.org
> http://openvswitch.org/mailman/listinfo/dev
