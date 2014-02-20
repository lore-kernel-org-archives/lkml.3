Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615AbaBTSRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 13:17:32 -0500
Received: from nm37.bullet.mail.ne1.yahoo.com ([98.138.229.30]:23794 "EHLO
	nm37.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755563AbaBTSRa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 13:17:30 -0500
X-Yahoo-Newman-Property: ymail-4
X-Yahoo-Newman-Id: 515352.98945.bm@omp1044.mail.ir2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=qxwg6Iry39yfpKtpR5XI1/uAbXQqtk7mBQpuk5Psg9brv39qnZSP3kcVKYoFMZyDk74mfn5L/WLcI8YucTxyLoV5nGdm4Thibyws8iivQG6OS7liaZiw4S1iiFC1BzhthDUVBb9twtVSFGoMkvhN+NBAwE42zKSD/oD4bhXNHGE=;
X-YMail-OSG: KTQ02YUVM1mYvZtXR_NYnoTGAKyC517nHHapZHWiQTAjGSc
 9tBwD9eahZnloDDMRGHIyzF320jxxz6TO_REIRw6C98XjmfeeED.XK5TNyeq
 li6kI5Mvw4PsbGG6Sxy3yyAhTvKH9wL6X8WaKY2ApqmTY3od0UtdofuhXGLE
 3RHfsu2dg3ojdUD9WrhB7me1oUd3056KS93xkEzBIPqcswUK4KwFOKQn7YuJ
 n97M1pF6lHTyKGWswfKIkyzodhv6Z..tOe1toRV_PEy0zUU21uAPpuKaVnUX
 rP1v.woUPmA_ZETtDA_.mNgN9txlwHsTmmnec9W9V4JE9B8y_OtmCyaMd1zM
 q80gZ0dUulnmzTW7L6QHljQVBqCyZnTEIx3MpkoaeL5STEpaNDs2_fo9WTEs
 1nfaSYax.Rr2hlnp30Q5mqTQNfolAGg6_eVhLUiHn_sxCLxv9vMy67n_Quc4
 MjNcoibEOSSU5GyA5wKsta9pvhiMziUaDblxVOGKBwWeG8ROVpTGTtOAA_tz
 Fbexi2sSn88Ya4rF6gVeEfE4cHVWoui_sgPVssScI3FyZkgsA6IwZBeBnh_V
 MotE6C6KHymflUw99FNhXfwmyG_D2hDUtMKL_qOCNB2q9ntJVORapIxuTKTB
 IWcEM7T6Lcw--
X-Rocket-MIMEInfo: 002.001,SGksCgpJIGhhdmUgY3VycmVudGx5IGZvbGxvd2luZyBzZXR1cCB3aXRoIHRocmVlIGRldmljZXMgKGFjdHVhbCAzIGhhcmR3YXJlIGJveGVzKQoKYm94MSDCoCDCoCDCoCBib3gyIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgYm94MwpjbGllbnQgLS0.IChldGgwKVticmlkZ2luZyBkZXZpY2VdKGV0aDEpIC0tPiBzZXJ2aWNlIHgKCgpUaGUgYnJpZGdpbmcgZGV2aWNlIGNoZWNrcyB0aGUgcHJvcGVydGllcyBvZiAiY2xpZW50IiBhbmQgbWF5YmUgcmVkaXJlY3RzCmhpbSB0byABMAEBAQE-
X-Mailer: YahooMailWebService/0.8.177.636
Message-ID: <1392920071.66303.YahooMailNeo@web172306.mail.ir2.yahoo.com>
Date: Thu, 20 Feb 2014 18:14:31 +0000 (GMT)
From: Artie Hamilton <artiemhamilton@yahoo.com>
Reply-To: Artie Hamilton <artiemhamilton@yahoo.com>
Subject: BUG: ip6tables IPv6-REDIRECT over bridges
To: Pablo Neira Ayuso <pablo@netfilter.org>, Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "\"David S. Miller\"" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "netfilter@vger.kernel.org" <netfilter@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have currently following setup with three devices (actual 3 hardware boxes)

box1       box2                              box3
client --> (eth0)[bridging device](eth1) --> service x


The bridging device checks the properties of "client" and maybe redirects
him to a server on the bridging device (just assume HTTP for now). The
user is then welcomed and some instructions are shown. Before anyone
asks: NO, this is not a security mechanism.

The bridging device is a linux device and currently works perfectly fine with
IPv4 redirections. It is done (heavily simplified version) by running.

$ brctl addbr br0
$ brctl addif br0 eth0
$ brctl addif br0 eth1
$ ip addr add 192.168.1.42/24 dev br0
$ sysctl -w net.bridge.bridge-nf-call-iptables=1
$ iptables -t nat -A PREROUTING -p tcp -m tcp --dport 8080 -j REDIRECT --to-ports 81

This works perfectly fine with IPv4 services. Everyone is happy about the
bridged setup and the extra functionality with special redirects for this IPv4
service.

Now the same thing should be done for IPv6. It should works quite similar
(I just assume the above mentioned steps are already done):

$ sysctl -w net.ipv6.conf.br0.accept_ra=2
$ sysctl -w net.bridge.bridge-nf-call-ip6tables=1
$ ip6tables -t nat -A PREROUTING -p tcp -m tcp --dport 8080 -j REDIRECT --to-ports 81

But here is the problem: Connections will not be started. I see for example
connections getting started to the service like this on the client:

$ curl -6 -D - 'http://\[2001:1234::1\]:8080/'
..... nothing .....

A dump shows as first packet at tcp SYN to the service 2001:1234::1 with port
8080. And sometimes I see following too:

 * ICMPv6 redirect reply
 * SYN+ACK from fde9:....:d320 (one of the addresses of br0 but not
   from the actual range 2001:..../64) with port 81 !!!!!!!!!
 * RST from client to fde9:....:d320 with port 81

This seems to be a bug in nat or conntrack, right?

The conntrack event output show this:

    [NEW] tcp      6 120 SYN_SENT src=2001:...::3 sport=49495 dport=8080 [UNREPLIED] src=fde9:....:d320 sport=81 dport=49495

I've also tried following setups:

 * bridge setup but DNAT to service y (some server next to service x)
   $ ip6tables -t nat -A PREROUTING -p tcp -m tcp --dport 8080 -j DNAT --to-dest [2001:1234::2]:81
   => works
 * routing setup (br0 only contains eth0 and eth1 is a separate device)
   $ iptables -t nat -A PREROUTING -p tcp -m tcp --dport 8080 -j REDIRECT --to-ports 81
   => works

When I use curl on the IPv6 address of the bridge device (2001:1234::1337) then
it works on the actual server port 81 and the port which should get redirected
to 81 - port 8080:

$ curl -6 -D - 'http://\[2001:1234::1337)\]:81/'

HTTP/1.1 200 OK
....
$ curl -6 -D - 'http://\[2001:1234::1337)\]:8080/'
HTTP/1.1 200 OK
....

It really seems to be a bug when doing DNAT/REDIRECT with bridges and IPv6. And
it is not possible for me to change the previously mentioned setup to a routed
setup.

I've also read a little bit about TPROXY but found no good way to use it
together with this bridged setup without routing rules (but worked quite well in
routing).

