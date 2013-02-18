Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab3BRPdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 10:33:32 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:42764 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225Ab3BRPdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 10:33:31 -0500
Date: Mon, 18 Feb 2013 17:33:16 +0200
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: SYSFS "errors"
Message-ID: <20130218153316.GA2663@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

there are today a number of SYSFS files with read permission set but
can't really be read (tried with normal user and root). To make things
simpler, I wrote a simple ruby script (see below) to check if the file
is world writeable or if it has Read permission but throws an exception
when read (note that I ignore files which return empty buffers since
ruby cries about it).

Here are some results from my desktop PC:

$ ruby sysfs_errors.rb |wc -l
968

# ruby sysfs_errors.rb | wc -l
1602

8<---------------------------- cut here --------------------------------

Dir.glob("/sys/**/*").each do |file|
	next if File.directory?(file)

	if File.world_writable?(file)
		puts "#{file} is world-writable"
	end

	if File.readable?(file)
		begin
			File.open(file) { |f|
				result =3D f.readline
			}
		rescue EOFError
			nil
		rescue =3D> e
			puts e.message
		end
	end
end

I wonder if that should be sorted out or should we leave it as is ? If
it helps in any way, I have printed below only the filenames (without
path) so I could pipe it through uniq:

act_mask
audit
autosuspend_delay_ms
bind
bl_curve
clear
compact
delete
delete_device
drivers_probe
drvctl
duplex
em_buffer
enable
end_lba
event_char
hard_offline_page
host_reset
mode
new_device
new_id
pid
probe
reconfig
release
reload
remove
remove_id
rescan
reset
reset_counters
resource0
resource1
resource1_wc
resource2
resource3
resource4
resource5
rom
rotate_all
scan
sdram_scrub_rate
smi_request
soft_offline_page
speed
start_lba
sw_activity
trigger_fs_error
uevent
unbind
unload_heads

--=20
balbi

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRIkm8AAoJEIaOsuA1yqREExUQAI1J68fTLbz28tBNu7ApU0nx
hCcaenAOoTKQ2z59iaUz39w/OmSjDpF4sZoP3R5qf9ajevMsrR81okMWT7fXBvqW
xeXfEdaq33XmhG6papYqLxek12EDz015X5FfA8SJQKivRDuXXmxCptPgRSzERqT9
B0+l8Ubkjho2Gb/lvWHmiFI98CvuXxIJ2u1vr8iajTaS7KQKXHm62+HSW5ntn/8m
BhKX6Q/nfrgiVzsJm2dMP4SlPE4aXCzoZqAqX7V6Ae67un2EueMMnDd8o3fsB5cb
W47AKUcphxFF21v/OhfB13GfhHpSFqgYrB8UxQf4ZH/u1WXW03NXW2AoMq+lT/PU
0DUIqYaxmWkeDGYfRmWna9HRC+GGEUHsLLy+i9sy0/Dhm8HCxIqo6Km3MGQqZkmE
0ovneSGlUwFGwOTbu5c8F/cIvI7CC3o2exMrXYWySJuZwm5zdQmuHQuEDtRchkwd
RTYshGro4CSVCu5NIBXAPY4UWHSeIivhwPtpMsWrG0KSlgmZ7l8G1GWof0ubPyOl
Ot0zrPJBYv3aMARqpxsYmY9MCVAA41lSjId1jttlvDR+/AIQdHvYRwsk4NG03b88
F7l/zjEiXMsCNJkdShaDzCk0ysXUoGgbhyodNPIaFYA0/9viKxVsHVEHe6Fenlnd
qLcl7z1FmqorLAovQxdb
=Ok3D
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
