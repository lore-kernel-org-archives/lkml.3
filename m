Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab3J0CbP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 22:31:15 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:37855 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab3J0Ca5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 22:30:57 -0400
MIME-Version: 1.0
In-Reply-To: <20131026074819.6a5f4e24@samsung-9>
References: <1382687360-27794-1-git-send-email-zwu.kernel@gmail.com>
	<20131025084134.6cfa153a@samsung-9>
	<CAEH94Lia4VVU6Vnn_7DhOHo4yhR-tsMPu7biMCeSMgQPvkQrug@mail.gmail.com>
	<20131026074819.6a5f4e24@samsung-9>
Date: Sun, 27 Oct 2013 10:30:56 +0800
Message-ID: <CAEH94LjOnWgchhV__TLK9se-Cb3WkGnVfNZgNBBLdZL0kNM=-g@mail.gmail.com>
Subject: Re: [PATCH 1/3] vxlan: silence one build warning
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: netdev@vger.kernel.org, linux-kernel mlist <linux-kernel@vger.kernel.org>,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI, Stephen

I saw it on Fedora 17 without latest kernel. Then what do you think
that it is appropriate to solve this problem? discard this patch? If
yes, i can also agree.


On Sat, Oct 26, 2013 at 10:48 PM, Stephen Hemminger
<stephen@networkplumber.org> wrote:
> On Sat, 26 Oct 2013 15:06:04 +0800
> Zhi Yong Wu <zwu.kernel@gmail.com> wrote:
>
>> On Fri, Oct 25, 2013 at 11:41 PM, Stephen Hemminger
>> <stephen@networkplumber.org> wrote:
>> > On Fri, 25 Oct 2013 15:49:18 +0800
>> > Zhi Yong Wu <zwu.kernel@gmail.com> wrote:
>> >
>> >> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>> >>
>> >> drivers/net/vxlan.c: In function ‘vxlan_sock_add’:
>> >> drivers/net/vxlan.c:2298:11: warning: ‘sock’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>> >> drivers/net/vxlan.c:2275:17: note: ‘sock’ was declared here
>> >>   LD      drivers/net/built-in.o
>> >>
>> >> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>> >> ---
>> >>  drivers/net/vxlan.c | 2 +-
>> >>  1 file changed, 1 insertion(+), 1 deletion(-)
>> >>
>> >> diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
>> >> index 2ef5b62..e15f1af 100644
>> >> --- a/drivers/net/vxlan.c
>> >> +++ b/drivers/net/vxlan.c
>> >> @@ -2272,7 +2272,7 @@ static struct vxlan_sock *vxlan_socket_create(struct net *net, __be16 port,
>> >>  {
>> >>       struct vxlan_net *vn = net_generic(net, vxlan_net_id);
>> >>       struct vxlan_sock *vs;
>> >> -     struct socket *sock;
>> >> +     struct socket *sock = NULL;
>> >>       struct sock *sk;
>> >>       int rc = 0;
>> >>       unsigned int h;
>> >
>> > This only happens with certain versions of Gcc which have buggy dependency
>> > analysis. It doesn't happen with Gcc 4.7, think it only shows up in 4.4.
>> > I would rather not fix the warning this way since it risks masking later bugs if this code ever changes.
>> Gcc version is 4.7.2 on my box, this warning took palce.
>> # gcc -v
>> Using built-in specs.
>> COLLECT_GCC=gcc
>> ...
>> gcc version 4.7.2 20120921 (Red Hat 4.7.2-2) (GCC)
>>
>>
>
> I dont see it on Debian 7.
> $ gcc -v
> Using built-in specs.
> COLLECT_GCC=/usr/bin/gcc-4.7.real
> COLLECT_LTO_WRAPPER=/usr/lib/gcc/x86_64-linux-gnu/4.7/lto-wrapper
> Target: x86_64-linux-gnu
> Configured with: ../src/configure -v --with-pkgversion='Debian 4.7.2-5' --with-bugurl=file:///usr/share/doc/gcc-4.7/README.Bugs --enable-languages=c,c++,go,fortran,objc,obj-c++ --prefix=/usr --program-suffix=-4.7 --enable-shared --enable-linker-build-id --with-system-zlib --libexecdir=/usr/lib --without-included-gettext --enable-threads=posix --with-gxx-include-dir=/usr/include/c++/4.7 --libdir=/usr/lib --enable-nls --with-sysroot=/ --enable-clocale=gnu --enable-libstdcxx-debug --enable-libstdcxx-time=yes --enable-gnu-unique-object --enable-plugin --enable-objc-gc --with-arch-32=i586 --with-tune=generic --enable-checking=release --build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=x86_64-linux-gnu
> Thread model: posix
> gcc version 4.7.2 (Debian 4.7.2-5)



-- 
Regards,

Zhi Yong Wu
